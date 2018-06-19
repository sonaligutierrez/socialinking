require "test_helper"

class ExtractDataInBatchJobTest < ActiveJob::TestCase
  def setup
    @fb_post = posts(:three)
  end

  test "scraping execution for a post" do
    VCR.use_cassette("fb_scraping") do
      count = ExtractDataInBatchJob.perform_now @fb_post
      assert_equal(@fb_post.post_comments.count, count)
    end
  end
end
