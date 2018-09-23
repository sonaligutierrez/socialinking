require "test_helper"

class ExtractDataWatirInBatchJobTest < ActiveJob::TestCase
  def setup
    @fb_post_photo = posts(:watir_1)
    @fb_post = posts(:watir_2)
  end

  test "scraping execution for a post" do
    count = ExtractDataWatirInBatchJob.perform_now @fb_post
    assert_equal(15, @fb_post.post_comments.count)
  end

  test "scraping execution for a post with photo" do
    count = ExtractDataWatirInBatchJob.perform_now @fb_post_photo
    assert_equal(116, @fb_post_photo.post_comments.count)
  end
end
