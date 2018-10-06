# Lib for process the scraping by facebook post
# ie:
#   url = "https://m.facebook.com/story.php?story_fbid=1089390984533567&id=543211639151507"
#   fps = FacebookPostScraping.new(url)
#   fps.login
#   fps.process
#
# It must return the number of comment processed

class FacebookPostScrapingWatir
  attr_accessor :post_url, :browser, :fb_user, :fb_pass, :comments, :page, :finish_paging, :cookie_json, :proxy, :debug, :start_time, :headless, :message

  MAX_SCRAPING_TIME = 600 # sec

  def initialize(post_url, user, pass, cookie_json, proxy, headless = true, debug = false)
    @post_url = post_url
    @fb_user = user
    @fb_pass = pass
    @cookie_json = cookie_json
    @proxy = proxy
    @headless = headless
    @debug = debug
    @message = ""
    set_proxy
  end

  def login
    print_debug "Login", @cookie_json
    if @cookie_json
      resp = login_with_cookie
      unless resp
        login_with_user_and_pass
      else
        true
      end
    else
      login_with_user_and_pass
    end
  end

  def get_cookie_json
    @browser.cookies.to_a.to_json
  end

  def set_proxy
    print_debug "Set Proxy", @proxy
    capabilities = Selenium::WebDriver::Remote::Capabilities.chrome
    capabilities["chrome.page.customHeaders.Accept-Language"] = "en-US"
    capabilities["intl.accept_languages"] = "en-US"
    unless @proxy.to_s.empty?
      proxies = ["--proxy-server=23.106.16.75:29842", "--proxy-auth=mmacer:nk4YWBdc", "--incognito", "--disable-notifications", "--start-maximized", "--privileged"]
      @browser = Watir::Browser.new :chrome, switches: proxies, headless: @headless, desired_capabilities: capabilities
      @browser.goto("http://mmacer:nk4YWBdc@google.com/")
    else
      options = ["--incognito", "--disable-notifications", "--start-maximized", "--privileged"]
      @browser = Watir::Browser.new :chrome, switches: options, headless: @headless, desired_capabilities: capabilities
      @browser.goto("https://www.google.com/")
    end
  end

  def login_with_user_and_pass
    print_debug "Login With User And Pass", ""
    @browser.goto("https://m.facebook.com/a/language.php?l=en_US&lref=https%3A%2F%2Fm.facebook.com%2F%3Frefsrc%3Dhttps%253A%252F%252Fm.facebook.com%252F&gfid=AQASICdU5DBrEyI_&refid=8")
    if @browser.a(text: "Log In").exist?
      @browser.a(text: "Log In").click
    end
    @browser.text_field(id: "m_login_email").set(@fb_user)
    @browser.text_field(id: "m_login_password").set(@fb_pass)
    if @browser.button(text: "Log In").exist?
      @browser.button(text: "Log In").click
    else
      return false
    end
    print_debug "Login With User And Pass - Page", "" # @browser.body.html

    if @browser.a(text: "Did you forget your password?").exist?
      @message += "Error in login/pass for login. "
      @message += "User Disabled by FB. " if @browser.div(text: "Your Account Has Been Disabled").exist?
      return false
    else
      @message += "Logged with User/Pass. "
      return true
    end
  end

  def login_with_cookie
    print_debug "Login With Cookie", @cookie_json
    unless @cookie_json.empty?
      @browser.goto("https://www.facebook.com/")
      @browser.a(text: "English (US)").click! if @browser.a(text: "English (US)").exist?
      set_cookie
      @browser.refresh
      print_debug "Login With Cookie - Page - Before Check Cookie Login", @browser.body.html
      if @browser.element(css: ".removableItem").exist?
        @browser.element(css: ".removableItem").click
        if @browser.text_fields(id: "pass").count > 1
          @browser.text_fields(id: "pass").last.set(@fb_pass)
          if @browser.buttons(text: "Log In").count > 1
            @browser.buttons(text: "Log In").last.click
          end
        end
      end
      sleep(3)
      print_debug "Login With Cookie - Page - After Check Cookie Login", @browser.body.html
      if @browser.a(text: "Did you forget your password?").exist? || @browser.a(text: "Forgot account?").exist? || @browser.a(text: "Create New Account").exist?
        @message += "Error in Cookie for Login. "
        @message += "User Disabled by FB. " if @browser.div(text: "Your Account Has Been Disabled").exist?
        return false
      else
        @message += "Logged with Cookie. "
        return true
      end
    else
      return false
    end
  end

  def set_cookie
    saved_cookies = JSON.parse(cookie_json)
    saved_cookies.each do |saved_cookie|
      @browser.cookies.add(saved_cookie["name"], saved_cookie["value"], path: saved_cookie["path"] ? saved_cookie["path"] : "/", domain: saved_cookie["domain"] ? saved_cookie["domain"] : ".facebook.com", secure: saved_cookie["secure"] ? saved_cookie["secure"] : false)
    end
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
      print_debug "Process - First Page - Comments", @comments.count.to_s
    end

    @comments.length
  end

  def get_page_info
    if @page
      objectOG = OpenGraphReader.fetch(@post_url)
      page_info = {}
      if objectOG
        page_info[:title] = objectOG.og&.title unless objectOG.og&.title&.nil?
        page_info[:description] = objectOG.og&.description unless objectOG.og&.description&.nil?
        page_info[:image] = objectOG.og&.image&.url unless objectOG.og&.image&.nil?
      end
      page_info
    else
      nil
    end
  end

  def close
    @browser.close
  end

  private

    def print_debug(title, value)
      if @debug
        puts "#{title}:"
        puts value
      end
    end

    def check_and_get_post_url
      @post_url.gsub("m.facebook.com", "www.facebook.com")
    end

    def get_comments
      print_debug "Process - Comments", "getting...."
      result_comments = []
      begin
        @browser.element(css: ".permalinkPost .uiPopover").wait_until_present(timeout: 5)
      rescue Watir::Wait::TimeoutError => error
      end

      if @browser.elements(css: ".permalinkPost .uiPopover").count > 1
        if @browser.elements(css: ".permalinkPost .uiPopover").last.exist?
          element = @browser.elements(css: ".permalinkPost .uiPopover").last
          @browser.scroll.to(:top).by(0, element.location.y - 100)
          element.click
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
        sleep 2
        if get_execution_time > MAX_SCRAPING_TIME
          @message += "Scraping Time up. "
          @start_time = nil
          break
        end
      end

      comments = @browser.elements(css: ".permalinkPost .UFIComment")
      comments = @browser.elements(css: ".UFIList").first.elements(css: ".UFIComment") if comments.count == 0 && @browser.elements(css: ".UFIList").count > 0
      @message += "Comments found: #{comments.count}. "
      print_debug "Process - Comments - Scraping", comments.count.to_s
      comments.each do |comment|
        begin

          reactions = ""
          reactions_description = ""
          responses = ""
          user = comment.a(css: ".UFICommentActorName").text
          url_profile = comment.a(css: ".UFICommentActorName").href

          text_comment = comment.span(css: ".UFICommentBody").text

          date_comment = comment.a(css: ".uiLinkSubtle").text

          id_comment = comment.a(css: ".uiLinkSubtle").href.split("?").last.split("&")[0].split("comment_id=").last

          if comment.span(css: ".UFISutroLikeCount").exist?
            reactions = comment.span(css: ".UFISutroLikeCount").text
          end
          if get_execution_time > MAX_SCRAPING_TIME
            @message += "Scraping Time up. "
            return result_comments
          end

          responses = comment.span(css: ".UFIReplySocialSentenceLinkText").text if comment.span(css: ".UFIReplySocialSentenceLinkText").exist?
          result_comments << { id_comment: id_comment, user: user, url_profile: url_profile, date_comment: date_comment, comment: text_comment, reactions: reactions, reactions_description: reactions_description, responses: responses } unless text_comment.to_s.empty? && id_comment.to_s.empty?
        rescue Exception => e
          puts e.message
        end
      end
      @message += "Comments scraped: #{result_comments.count}. "
      result_comments
    end

    def get_execution_time
      @start_time = DateTime.now if @start_time.nil?
      end_time = DateTime.now
      seconds = ((end_time - @start_time) * 24 * 60 * 60).to_i
      seconds
    end

    def get_next_url(page)
      next_url = page.link_with(text: " Ver comentarios siguientes…")&.href || page.link_with(text: " Ver comentarios anteriores…")&.href || page.link_with(text: " Ver más comentarios…")&.href || page.link_with(text: " View more comments…")&.href || page.link_with(text: " View previous comments…")&.href
      print_debug "Get Next Url", next_url.to_s
      unless next_url
        temp_url = page.canonical_uri.to_s
        temp_url.sub! "www.facebook.com", "m.facebook.com"
        temp_url = temp_url.split("&").map do |m|
          if m[0] == "p"
            actual_page = m.split("=").last.to_i
            actual_page += 1
            "p=#{actual_page}"
          else
            m
          end
        end
        @finish_paging += 1
        return temp_url.join("&")
      else
        if get_execution_time > MAX_SCRAPING_TIME
          print_debug "Get Next Url - TimeUp", next_url.to_s
          @finish_paging = 1
        else
          @finish_paging = 0
        end
        return next_url
      end
      end
end
