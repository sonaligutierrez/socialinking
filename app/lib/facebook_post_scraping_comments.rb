# Lib for process the scraping by facebook post
# ie:
#   url = "https://m.facebook.com/story.php?story_fbid=1089390984533567&id=543211639151507"
#   fps = FacebookPostScraping.new(url)
#   fps.login
#   fps.process
#
# It must return the number of comment processed

class FacebookPostScrapingComments < FacebookPostScraping
  def initialize(post_url, user, pass, cookie_json, proxy, headless = true, debug = false)
    super(post_url, user, pass, cookie_json, proxy, headless, debug)
    @message = "#{self.class.name}: "
  end

  def process
    print_debug "Process", check_and_get_post_url
    @start_time = DateTime.now
    @comments = []
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
      @comments = get_comments
      print_debug "Process - First Page - Comments", @comments.to_s
    end

    @comments
  end

  private

    def get_comments
      print_debug "Process - Comments", "getting...."
      result_comments = 0
      begin
        @browser.element(css: ".permalinkPost .uiPopover").wait_until_present(timeout: 5)
      rescue Watir::Wait::TimeoutError => error
      end

      if @browser.elements(css: ".permalinkPost .uiPopover").count > 1
        if @browser.elements(css: ".permalinkPost .uiPopover").last.exist?
          element = @browser.elements(css: ".permalinkPost .uiPopover").last
          @browser.scroll.to(:top).by(0, element.location.y - 100)
          element.click!
        end
        if @browser.elements(css: ".__MenuItem").count == 3
          if @browser.elements(css: ".__MenuItem").last.exist?
            @browser.elements(css: ".__MenuItem").last.click!
          end
        end
      end

      begin
        @browser.element(css: ".permalinkPost a.UFIPagerLink").wait_until_present(timeout: 5)
      rescue Watir::Wait::TimeoutError => error
      end

      while @browser.element(css: ".permalinkPost a.UFIPagerLink").exist?
        element = @browser.elements(css: ".permalinkPost a.UFIPagerLink").last
        @browser.scroll.to(:top).by(0, element.location.y - 100)
        @browser.element(css: ".permalinkPost a.UFIPagerLink").click!
        sleep 1
        if get_execution_time > MAX_SCRAPING_TIME
          @message += "Scraping Time up. "
          @start_time = nil
          break
        end
      end

      comments_scraping_version = :v1
      if @browser.elements(css: ".permalinkPost").count >= 1
        comments_html = @browser.elements(css: ".permalinkPost").first.html
      elsif @browser.elements(css: ".UFIList").count >= 1
        comments_html = @browser.elements(css: ".UFIList").first.html
      elsif @browser.elements(css: ".commentable_item").count >= 1
        comments_html = @browser.elements(css: ".commentable_item").first.html
        comments_scraping_version = :v2
      else
        comments_html = "<div></div>"
      end

      close

      page = Nokogiri::HTML(comments_html)
      comments = page.css(COMMENTS_SCRAPING_VERSIONS[comments_scraping_version][:comments])
      @message += "Comments found: #{comments.count}. "
      print_debug "Process - Comments - Scraping", comments.count.to_s
      comments.each do |comment|
        reactions = ""
        reactions_description = ""
        responses = ""
        text_comment = ""
        id_comment = ""

        begin
          user = comment.css(COMMENTS_SCRAPING_VERSIONS[comments_scraping_version][:user]).text
          url_profile = comment.css(COMMENTS_SCRAPING_VERSIONS[comments_scraping_version][:url_profile]).first.attributes["href"].text
          avatar_url = comment.css(COMMENTS_SCRAPING_VERSIONS[comments_scraping_version][:avatar_url]).first.attributes["src"].text

          text_comment = comment.css(COMMENTS_SCRAPING_VERSIONS[comments_scraping_version][:text_comment]).text

          date_comment = comment.css(COMMENTS_SCRAPING_VERSIONS[comments_scraping_version][:date_comment]).first.text
          date_time = comment.css(COMMENTS_SCRAPING_VERSIONS[comments_scraping_version][:date_time]).first.attributes["title"].text.to_datetime

          id_comment = comment.css(COMMENTS_SCRAPING_VERSIONS[comments_scraping_version][:id_comment]).first.attributes["href"].text.split("?").last.split("&")[0].split("comment_id=").last

          reactions = comment.css(COMMENTS_SCRAPING_VERSIONS[comments_scraping_version][:reactions]).text

          responses = comment.css(COMMENTS_SCRAPING_VERSIONS[comments_scraping_version][:responses]).text
        rescue Exception => e

        end

        unless text_comment.to_s.empty? && id_comment.to_s.empty?
          result_comment = { id_comment: id_comment, user: user, url_profile: url_profile, date_comment: date_comment, comment: text_comment, reactions: reactions, reactions_description: reactions_description, responses: responses, date: date_time, avatar: avatar_url }

          fb_user = FacebookUser.where(fb_username: clean_url_profile(result_comment[:url_profile])).first_or_create(fb_name: result_comment[:user], fb_avatar: result_comment[:avatar])

          if fb_user
            the_comment = PostComment.find_by_id_comment(result_comment[:id_comment])
            if the_comment
              the_comment.update(date_comment: result_comment[:date_comment], reactions: result_comment[:reactions], reactions_description: result_comment[:reactions_description], responses: result_comment[:responses], date: result_comment[:date], post_id: @post_id, facebook_user_id: fb_user.id)
            else
              the_comment = PostComment.create(post_id: @post_id, facebook_user_id: fb_user.id, id_comment: result_comment[:id_comment], date_comment: result_comment[:date_comment], reactions: result_comment[:reactions], reactions_description: result_comment[:reactions_description], responses: result_comment[:responses], category_id: Category.find_by_name("Uncategorized").id, comment: result_comment[:comment], date: result_comment[:date])

            end
            result_comments += 1 if the_comment
          end
        end
      end
      @message += "Comments scraped: #{result_comments}. "
      result_comments
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

    COMMENTS_SCRAPING_VERSIONS = {
      v1: {
        comments: ".UFIComment",
        user: "a.UFICommentActorName",
        url_profile: "a.UFICommentActorName",
        avatar_url: "img.UFIActorImage",
        text_comment: "span.UFICommentBody",
        date_comment: "a.uiLinkSubtle > abbr",
        date_time: "a.uiLinkSubtle > abbr",
        id_comment: "a.uiLinkSubtle",
        reactions: "span.UFISutroLikeCount",
        responses: "span.UFIReplySocialSentenceLinkText"
      },
      v2: {
        comments: "div > div > ul > li",
        user: "div > div > div > div > div > div > div > div > div > div > a",
        url_profile: "div > div > div > div > div > div > div > div > div > div > a",
        avatar_url: "div > div > a > img",
        text_comment: "div > div > div > div > div > div > div > div > div > div > span > span > span",
        date_comment: "abbr",
        date_time: "abbr",
        id_comment: "ul > li:last > a",
        reactions: "div > div > div > div > div > div > div > span > span > a > span",
        responses: ".xxx"
      }
    }
end
