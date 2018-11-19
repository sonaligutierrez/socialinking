# Lib for process the scraping by facebook post
# ie:
#   url = "https://m.facebook.com/story.php?story_fbid=1089390984533567&id=543211639151507"
#   fps = FacebookPostScraping.new(url)
#   fps.login
#   fps.process
#
# It must return the number of comment processed

class FacebookPostScrapingReactions < FacebookPostScraping
  attr_accessor :reactions

  def initialize(post_url, user, pass, cookie_json, proxy, headless = true, debug = false)
    super(post_url, user, pass, cookie_json, proxy, headless, debug)
    @message = "#{self.class.name}: "
  end

  def process
    print_debug "Process", check_and_get_post_url
    @start_time = DateTime.now
    @reactions = []
    @finish_paging = 0
    if @browser
      @browser.goto(check_and_get_post_url)
      print_debug "Process - First Page", "" # @browser.body.html
      # Clean view when it is a photo/video post
      begin
        @browser.element(css: ".fbPhotoSnowlift > div > div > a").wait_until_present(timeout: 3)
        if @browser.element(css: ".fbPhotoSnowlift > div > div > a").present? && @browser.element(css: ".fbPhotoSnowlift > div > div > a").exist?
          @browser.element(css: ".fbPhotoSnowlift > div > div > a").click!
          @message += "Got Image/Video cover Post. "
        end
        @browser.element(css: ".fbPhotoSnowlift > div > div > a").wait_while_present(timeout: 3)
      rescue Watir::Wait::TimeoutError => error
      end
      @reactions = get_reactions
      print_debug "Process - reactions", @reactions.to_s
    end

    @reactions
  end

  private

    def get_reactions
      print_debug "Process - reactions", "getting...."
      result_reactions = 0

      # Searching reactions link
      element = @browser.elements(css: ".commentable_item").first
      @browser.scroll.to(:top).by(0, element.location.y - 100)

      reactions_link = @browser.elements(css: ".commentable_item a span").first

      if reactions_link
        reactions_link.click!
        @browser.element(css: ".uiScrollableAreaContent a.uiMorePagerPrimary").wait_until_present(timeout: 3)
        while @browser.element(css: ".uiScrollableAreaContent a.uiMorePagerPrimary").exist?

          begin
            @browser.element(css: ".uiScrollableAreaContent a.uiMorePagerPrimary").wait_until_present(timeout: 3)
            @browser.element(css: ".uiScrollableAreaContent a.uiMorePagerPrimary").click
            rescue Watir::Wait::TimeoutError => error
          end
          if get_execution_time > MAX_SCRAPING_TIME
            @message += "Scraping Time up. "
            @start_time = nil
            break
          end
        end

        reactions_html = @browser.elements(css: ".uiScrollableAreaWrap > .uiScrollableAreaBody > .uiScrollableAreaContent").last.html

        close

        page = Nokogiri::HTML(reactions_html)
        reactions = page.css("li")
        @message += "reactions found: #{reactions.count}. "
        print_debug "Process - reactions - Scraping", reactions.count.to_s

        reactions.each do |reaction|
          # begin
          reactions = ""
          reactions_description = ""
          responses = ""
          user = reaction.css(".clearfix a").last.text
          url_profile = reaction.css(".clearfix a").first.attributes["href"].text
          avatar_url = reaction.css(".clearfix a .img").first.attributes["src"].text

          text_reaction = reaction.css(".clearfix a div div span i").first.attributes["class"].text.split(" ").first

          unless text_reaction.to_s.empty?
            result_reaction = { user: user, url_profile: url_profile, reaction: text_reaction, avatar: avatar_url }
            profile = clean_url_profile(result_reaction[:url_profile])
            fb_user = FacebookUser.where(fb_username: profile).first_or_create(fb_name: result_reaction[:user], fb_avatar: result_reaction[:avatar])

            if fb_user
              the_reaction = PostReaction.where(facebook_users_id: fb_user.id, posts_id: @post_id)
              if the_reaction.count >= 1
                the_reaction.first.update(reaction: result_reaction[:reaction])
              else
                the_reaction = PostReaction.create(posts_id: @post_id, facebook_users_id: fb_user.id, reaction: result_reaction[:reaction])
              end
              result_reactions += 1 if the_reaction
            end
          end
          # rescue Exception => e
          #   puts e.message
          # end
        end
      end

      @message += "reactions scraped: #{result_reactions}. "
      result_reactions
    end

    def clean_url_profile(url)
      unless url.empty?
        if url.include?("id=")
          url.split("&").first
        else
          url.split("?").first
        end
      else
        ""
      end
    end
end
