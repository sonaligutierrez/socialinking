# Lib for process the scraping by facebook profile
# ie:
#   url = "https://m.facebook.com/profile.php?id=100014441523990"
#   fps = FacebookProfileScraping.new(url)
#   fps.login
#   fps.process
#
# It must return the number of comment processed

class FacebookProfileScraping
  attr_accessor :profile, :agent, :fb_user, :fb_pass, :comments, :page, :finish_paging, :cookie_yml

  def initialize(profile, user, pass, cookie_yml)
    @profile = profile
    @fb_user = user
    @fb_pass = pass
    @cookie_yml = cookie_yml
  end

  def login
    if @cookie_yml
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

  def get_cookie_yml
    YAML.dump(@agent.cookie_jar)
  end

  def login_with_user_and_pass
    @agent = Mechanize.new
    @agent.user_agent_alias = "Linux Firefox"
    login_page = @agent.get("https://m.facebook.com/")
    login_form = @agent.page.form_with(method: "POST")
    login_form.email = @fb_user
    login_form.pass = @fb_pass
    @agent.submit(login_form)
    forget_password = @agent.page.links.find { |l| l.text == "Did you forget your password?" }

    forget_password.nil?
  end

  def login_with_cookie
    unless @cookie_yml.empty?
      @agent = Mechanize.new
      cookie_jar = YAML.load(@cookie_yml)
      @agent.user_agent_alias = "Linux Firefox"
      @agent.cookie_jar = cookie_jar
      @agent.get("https://m.facebook.com/")
      forget_password = @agent.page.links.find { |l| l.text == "Forgot Password?" || l.text == "Create Account" }

      forget_password.nil?
    else
      false
    end
  end

  def process
    if @agent
      @agent.get("https://m.facebook.com#{@profile.fb_username}") do |page|
        @page = page
        images = page.search("a img")
        images.each do |img|
          if img.attributes["alt"].text == @profile.fb_name
            @profile.fb_avatar = img.attributes["src"].text unless img.attributes["src"].nil?
            @profile.save
            break
          end
        end
      end
      return true
    end
    false
  end
end
