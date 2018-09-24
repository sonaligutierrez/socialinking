require "test_helper"

class ExtractDataWatirInBatchJobTest < ActiveJob::TestCase
  def setup
    @fb_post_photo = posts(:watir_1)
    @fb_post = posts(:watir_2)
    @fb_post_v2 = posts(:watir_3)
  end

  test "scraping execution for a post" do
    count = ExtractDataWatirInBatchJob.perform_now @fb_post
    assert_equal(true, @fb_post.post_comments.count > 10)
  end

  test "scraping execution for a post v2" do
    count = ExtractDataWatirInBatchJob.perform_now @fb_post_v2
    assert_equal(true, @fb_post_v2.post_comments.count > 10)
  end

  test "scraping execution for a post with photo" do
    count = ExtractDataWatirInBatchJob.perform_now @fb_post_photo
    assert_equal(true, @fb_post_photo.post_comments.count > 10)
  end
end
