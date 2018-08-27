require "test_helper"

class FacebookProfileScrapingAsPostCreatorTest < ActiveSupport::TestCase
  def setup
    @post_creator = post_creators(:three)
    @fb_profile_scraping = FacebookProfileScraping.new(@post_creator, "luiseloyhernandez@gmail.com", "xyzw123456", "", "")
  end

  def test_get_post_creator_avatar
    VCR.use_cassette("fb_profile", record: :new_episodes) do
      assert_equal true, @fb_profile_scraping.login
      assert_equal true, @fb_profile_scraping.get_post_creator_avatar
      assert_equal false, @post_creator.avatar.empty?
    end
  end
end
