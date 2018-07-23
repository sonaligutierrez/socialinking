require "test_helper"

class FacebookUserTest < ActiveSupport::TestCase
  test "get profile image url" do
    facebook_user = facebook_users(:one)
    VCR.use_cassette("fb_scraping_profile_info", record: :new_episodes) do
      facebook_user.scraping
      assert_equal false, facebook_user.fb_avatar.empty?
    end
  end
end
