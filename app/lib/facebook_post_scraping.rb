# Lib for process the scraping by facebook post
# ie:
#   url = "https://m.facebook.com/story.php?story_fbid=1089390984533567&id=543211639151507"
#   fps = FacebookPostScraping.new(url)
#   fps.login
#   fps.process
#
# It must return the number of comment processed

class FacebookPostScraping
  attr_accessor :post_url, :agent, :fb_user, :fb_pass, :comments, :page

  def initialize(post_url)
    @post_url = post_url
    @fb_user = "luiseloyhernandez@gmail.com"
    @fb_pass = "xyzw123456"
  end

  def login
    @agent = Mechanize.new
    @agent.user_agent_alias = "Android"
    login_page = @agent.get("https://m.facebook.com/")
    login_form = @agent.page.form_with(method: "POST")
    login_form.email = @fb_user
    login_form.pass = @fb_pass
    @agent.submit(login_form)
    forget_password = @agent.page.links.find { |l| l.text == "Did you forget your password?" }

    forget_password.nil?
  end

  def process
    @comments = []
    if @agent
      @agent.get(@post_url) do |page|
        @page = page
        scrapped_comments = get_comments(page)
        while scrapped_comments.length > 0
          @comments += scrapped_comments
          puts "Click"
          page = page.link_with(:text => ' Ver comentarios siguientes…').click
          scrapped_comments = get_comments(page)
          puts "scrapped_comments=#{scrapped_comments.length}"
          sleep(1)
        end
      end
    end
    @comments.length
  end

  private

  def get_comments(page)
    result_comments = []
    if page.code == "200"
      comments = page.search(".dw")
      byebug
      comments.each do |comment|
        user = comment.search(".dx").text
        text_comment = comment.search(".dy").text
        reactions = comment.search(".bx").text
        resp = comment.search(".ea")
        responses = nil
        responses = resp.last.text if resp.last
        result_comments << { user: user, comment: text_comment, reactions: reactions, responses: responses } unless text_comment.empty?
      end
    end
    return result_comments
  end
end
