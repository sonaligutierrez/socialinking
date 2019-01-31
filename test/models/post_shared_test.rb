require "test_helper"

class PostSharedTest < ActiveSupport::TestCase
  test "scraping comments with paging" do
    post = posts(:three)
    VCR.use_cassette("fb_scraping_shared") do
      assert_changes "PostShared.count > 100"  do
        post.scraping_shared
      end
    end
  end
end
