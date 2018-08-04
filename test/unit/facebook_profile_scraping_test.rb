require "test_helper"

class FacebookProfileScrapingTest < ActiveSupport::TestCase
  def setup
    @facebook_user = facebook_users(:one)
    @fb_profile_scraping = FacebookProfileScraping.new(@facebook_user, "luiseloyhernandez@gmail.com", "xyzw123456", "", "")
  end

  def test_login_success
    VCR.use_cassette("fb_login_success") do
      assert_equal true, @fb_profile_scraping.login
    end
  end

  def test_login_fail
    VCR.use_cassette("fb_login_fail") do
      @fb_profile_scraping.fb_pass = "xxxx"
      assert_equal false, @fb_profile_scraping.login
    end
  end

  def test_process
    VCR.use_cassette("fb_profile", record: :new_episodes) do
      assert_equal true, @fb_profile_scraping.login
      assert_equal true, @fb_profile_scraping.process
      assert_equal false, @facebook_user.fb_avatar.empty?
    end
  end
end
