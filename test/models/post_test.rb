require "test_helper"

class PostTest < ActiveSupport::TestCase
  test "scraping comments " do
    post = posts(:three)
    VCR.use_cassette("fb_scraping") do
      assert_difference "PostComment.count", 117  do
        post.scraping
      end
    end
  end

  test "scraping log " do
    post = posts(:three)
    VCR.use_cassette("fb_scraping") do
      assert_difference "ScrapingLog.count"  do
        post.scraping
      end
    end
  end
end
