require "test_helper"

class FacebookPostScrapingTest < Minitest::Test
  def setup
    @fb_post_scraping = FacebookPostScraping.new("https://m.facebook.com/story.php?story_fbid=1089390984533567&id=543211639151507")
  end

  def test_login_success
    VCR.use_cassette("fb_login_success") do
      assert_equal true, @fb_post_scraping.login
    end
  end

  def test_login_fail
    VCR.use_cassette("fb_login_fail") do
      @fb_post_scraping.fb_pass = "xxxx"
      assert_equal false, @fb_post_scraping.login
    end
  end

  def test_process
    VCR.use_cassette("fb_process") do
      assert_equal true, @fb_post_scraping.login
      assert_equal true, (@fb_post_scraping.process > 4)
      assert_equal "Dario Zapata", @fb_post_scraping.comments[0][:user]
      assert_equal "Socorro González Guerrico", @fb_post_scraping.comments[1][:user]
      assert_equal "Claudia Ines Castañer", @fb_post_scraping.comments[2][:user]
      assert_equal "María Cristina Bianchetti Arrechea", @fb_post_scraping.comments[3][:user]
    end
  end
end
