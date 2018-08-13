# Lib for process the scraping by facebook post
# ie:
#   url = "https://m.facebook.com/story.php?story_fbid=1089390984533567&id=543211639151507"
#   fps = FacebookPostScraping.new(url)
#   fps.login
#   fps.process
#
# It must return the number of comment processed

class FacebookPostScraping
  attr_accessor :post_url, :agent, :fb_user, :fb_pass, :comments, :page, :finish_paging, :cookie_yml, :proxy, :debug

  def initialize(post_url, user, pass, cookie_yml, proxy)
    @post_url = post_url
    @fb_user = user
    @fb_pass = pass
    @cookie_yml = cookie_yml
    @proxy = proxy
    @agent = Mechanize.new
    @agent.user_agent_alias = "Linux Firefox"
    @debug = false
  end

  def login
    print_debug "Login", @cookie_yml
    if @cookie_yml
      resp = login_with_cookie
      unless resp
        #@agent.cookie_jar.save("/tmp/cookies.yaml", session: true)
        login_with_user_and_pass
      else
        #@agent.cookie_jar.save("/tmp/cookies.yaml", session: true)
        true
      end
    else
      login_with_user_and_pass
    end
  end

  def get_cookie_yml
    YAML.dump(@agent.cookie_jar)
  end

  def set_proxy
    print_debug "Set Proxy", @proxy
    unless @proxy.to_s.empty?
      proxy_config = @proxy.split(":")
      @agent.set_proxy proxy_config[0], proxy_config[1], proxy_config[2], proxy_config[3]
    end
  end

  def login_with_user_and_pass
    print_debug "Login With User And Pass", ""
    set_proxy
    login_page = @agent.get("https://m.facebook.com/")
    login_form = @agent.page.form_with(method: "POST")
    login_form.email = @fb_user
    login_form.pass = @fb_pass
    @agent.submit(login_form)
    forget_password = @agent.page.links.find { |l| l.text == "Did you forget your password?" }
    print_debug "Login With User And Pass - Page", @agent.page.body.to_s
    forget_password.nil?
  end

  def login_with_cookie
    print_debug "Login With Cookie", @cookie_yml
    unless @cookie_yml.empty?
      set_proxy
      cookie_jar = YAML.load(@cookie_yml)
      @agent.cookie_jar = cookie_jar
      @agent.get("https://m.facebook.com/")
      forget_password = @agent.page.links.find { |l| l.text == "Forgot Password?" || l.text == "Create Account" || l.text == "Crear cuenta nueva" }
      print_debug "Login With Cookie - Page", @agent.page.body.to_s
      forget_password.nil?
    else
      false
    end
  end

  def process
    print_debug "Process", check_and_get_post_url
    @comments = []
    @finish_paging = 0
    if @agent
      @agent.get(check_and_get_post_url) do |page|
        @page = page
        print_debug "Process - First Page", @page.body.to_s
        scrapped_comments = get_comments(page)
        print_debug "Process - First Page - Comments", scrapped_comments.to_s
        url = get_next_url(page)
        while @finish_paging == 0
          @comments += scrapped_comments
          page = @agent.get(url)
          if page
            print_debug "Process - Page #{url}", @page.body.to_s
            scrapped_comments = get_comments(page)
            print_debug "Process - Page #{url} - Comments", scrapped_comments.to_s
            sleep(1)
            url = get_next_url(page)
          end
        end
        @comments += scrapped_comments
      end
    end

    @comments = @comments.select { |c| c[:id_comment][0] != "s" }
    @comments = @comments.index_by { |r| r[:id_comment] }
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

  private

    def print_debug(title, value)
      if @debug
        puts "#{title}:" 
        puts value
      end
    end

    def check_and_get_post_url
      @post_url.gsub("www.facebook.com", "m.facebook.com")
    end

    def get_comments(page)
      print_debug "Process - Comments", ""
      result_comments = []
      if page.code == "200"
        comments = page.search("div[id^='composer']")&.first&.next&.children || page.search("div[id^='sentence']")&.first&.next&.children || []
        print_debug "Process - Comments - Scraping", comments.to_s
        comments.each do |comment|
          begin

            reactions = ""
            reactions_description = ""
            user = comment.search("h3")&.text
            url_profile = comment.search("a")&.first&.attributes["href"]&.text&.split("?")&.first
            url_profile = comment.search("a")&.first&.attributes["href"]&.text&.split("&")&.first if url_profile == "/profile.php"

            text_comment = comment.search("h3")&.first&.next&.text

            date_comment = comment.search("abbr")&.text
            id_comment = comment.attributes["id"]&.text

            reaction_node = comment.search("span > span > a").first
            if reaction_node
              reactions = reaction_node&.text&.to_i
              reactions_description = reaction_node&.attributes["aria-label"]&.text
            end

            responses = comment.search("div > div > div a")&.text
            result_comments << { id_comment: id_comment, user: user, url_profile: url_profile, date_comment: date_comment, comment: text_comment, reactions: reactions, reactions_description: reactions_description, responses: responses } unless text_comment.to_s.empty? && id_comment.to_s.empty?
          rescue Exception => e
            puts e.message
          end
        end
      end
      result_comments
    end

    def get_next_url(page)
      next_url = page.link_with(text: " Ver comentarios siguientes…")&.href || page.link_with(text: " Ver más comentarios…")&.href || page.link_with(text: " View previous comments…")&.href
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
        @finish_paging = 0
        return next_url
      end
      end
end
