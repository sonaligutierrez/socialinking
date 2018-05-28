# Lib for process the scraping by facebook post
# ie:
#   url = "https://m.facebook.com/story.php?story_fbid=1089390984533567&id=543211639151507"
#   fps = FacebookPostScraping.new(url)
#   fps.login
#   fps.process
#
# It must return the number of comment processed

class FacebookPostScraping
  attr_accessor :post_url, :agent, :fb_user, :fb_pass, :comments, :page, :finish_paging, :cookie_yml

  def initialize(post_url, user, pass, cookie_yml)
    @post_url = post_url
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
    @agent = Mechanize.new
    cookie_jar = YAML.load(@cookie_yml)
    @agent.user_agent_alias = "Linux Firefox"
    @agent.cookie_jar = cookie_jar
    @agent.get("https://m.facebook.com/")
    forget_password = @agent.page.links.find { |l| l.text == "Forgot Password?" }

    forget_password.nil?
  end

  def process
    @comments = []
    @finish_paging = 0
    if @agent
      @agent.get(@post_url) do |page|
        @page = page
        scrapped_comments = get_comments(page)
        while @finish_paging < 4
          @comments += scrapped_comments
          puts "Next Page"
          page = @agent.get(get_next_url(page))
          if page
            scrapped_comments = get_comments(page)
            puts "scrapped_comments=#{scrapped_comments.length}"
            sleep(1)
          else
            byebug
          end
        end
      end
    end
    @comments = @comments.select { |c| c[:id_comment][0] != "s" }
    @comments = @comments.index_by { |r| r[:id_comment] }
    @comments.length
  end

  private

    def get_comments(page)
      result_comments = []
      if page.code == "200"
        comments = page.search(".dx, .ds")
        comments.each do |comment|
          begin
            # byebug
            user = comment.search("h3")&.text
            url_profile = comment.search("a")&.first&.attributes["href"]&.text&.split("?")&.first

            text_comment = comment.search(".ea, .dz, span")&.text

            date_comment = comment.search(".ec abbr")&.text
            id_comment = comment.attributes["id"]&.text

            reactions = comment.search(".eg")&.map { |m| m&.text }&.select { |x| x != "#" && !x&.empty? }&.first&.split(" ")&.first
            reactions_description = comment.search(".eg, .ek, .eg a, .ek a")&.map { |m| m.attributes["aria-label"]&.text }.select! { |x| !x.nil? }&.first

            responses = comment.search(".ek")&.map { |m| m&.text }&.select { |x| x != "#" && !x&.empty? }&.first&.split(" ")&.first
            result_comments << { id_comment: id_comment, user: user, url_profile: url_profile, date_comment: date_comment, comment: text_comment, reactions: reactions, reactions_description: reactions_description, responses: responses } unless text_comment.empty? && id_comment.empty?
          rescue Exception => e
            puts e.message
          end
        end
      end
      result_comments
    end

    def get_next_url(page)
      next_url = page.link_with(text: " Ver comentarios siguientes…")&.href
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
