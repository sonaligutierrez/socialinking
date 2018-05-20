require "test_helper"

class FacebookPostScrapingTest < Minitest::Test
  def setup
    @fb_post_scraping = FacebookPostScraping.new('https://m.facebook.com/story.php?story_fbid=1089390984533567&id=543211639151507')
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
    skip "test this later"
  end
end