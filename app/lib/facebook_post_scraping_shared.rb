# Lib for process the scraping by facebook post
# ie:
#   url = "https://m.facebook.com/story.php?story_fbid=1089390984533567&id=543211639151507"
#   fps = FacebookPostScraping.new(url)
#   fps.login
#   fps.process
#
# It must return the number of comment processed

class FacebookPostScrapingShared < FacebookPostScraping
  attr_accessor :shared

  def initialize(post_url, user, pass, cookie_json, proxy, headless = true, debug = false)
    super(post_url, user, pass, cookie_json, proxy, headless, debug)
    @message = "#{self.class.name}: "
  end

  def process
    print_debug "Process", check_and_get_post_url
    @start_time = DateTime.now
    @shared = []
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
      @shared = get_shared
      print_debug "Process - shared", @shared.to_s
    end

    @shared
  end

  private

    def get_shared
      print_debug "Process - shared", "getting...."
      result_shared = 0

      # Searching shared link
      shared_link = @browser.elements(css: '.commentable_item a[href^="/shares/view"]').first

      if shared_link
        shared_link.click!

        @browser.element(css: "#repost_view_dialog").wait_until_present(timeout: 10)
        count_to_exit = 0
        count_shared = 0
        last_count_shared = 0
        more_shared = true
        while more_shared && @browser.element(css: "#repost_view_dialog .uiMorePager").exist?
          element = @browser.element(css: "#repost_view_dialog .uiMorePager")
          @browser.scroll.to(:top).by(0, element.location.y - 100)
          sleep 1.seconds
          last_count_shared = @browser.elements(css: "#repost_view_dialog .userContentWrapper").count
          if count_shared == last_count_shared
            count_to_exit += 1
            if count_to_exit == 10
              more_shared = false
            end
          else
            count_shared = last_count_shared
            count_to_exit = 0
          end

          if get_execution_time > MAX_SCRAPING_TIME
            @message += "Scraping Time up. "
            @start_time = nil
            more_shared = false
          end
        end

        shared_html = @browser.element(css: "#repost_view_dialog").html

        # close

        page = Nokogiri::HTML(shared_html)
        shared = page.css(".userContentWrapper")
        @message += "shared found: #{shared.count}. "
        print_debug "Process - shared - Scraping", shared.count.to_s

        shared.each do |share|
          begin
            shared = ""
            shared_description = ""
            responses = ""
            user = share.css(".clearfix > .clearfix .profileLink").first.text
            url_profile = share.css(".clearfix > .clearfix .profileLink").first.attributes["href"].text
            avatar_url = share.css(".clearfix > .clearfix > a img").first.attributes["src"].text

            unless user.to_s.empty?
              result_share = { user: user, url_profile: url_profile, avatar: avatar_url }
              profile = clean_url_profile(result_share[:url_profile])
              fb_user = FacebookUser.where(fb_username: profile).first_or_create(fb_name: result_share[:user], fb_avatar: result_share[:avatar])

              if fb_user
                the_share = PostShared.where(facebook_users_id: fb_user.id, posts_id: @post_id)
                if the_share.count == 0
                  the_share = PostShared.create(posts_id: @post_id, facebook_users_id: fb_user.id)
                end
                result_shared += 1 if the_share
              end
            end
          rescue Exception => e
            puts e.message
          end
        end
      end

      @message += "shared scraped: #{result_shared}. "
      result_shared
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
