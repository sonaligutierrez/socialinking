require "test_helper"

class ExtractDataCommentsInBatchJobTest < ActiveJob::TestCase
  def setup
    @fb_post_photo = posts(:watir_1)
    @fb_post = posts(:watir_2)
    @fb_post_v2 = posts(:watir_3)
    categories(:one)
  end

  test "scraping execution for a post" do
    VCR.use_cassette("fb_scraping_watir_1") do
      count = ExtractDataComentsInBatchJob.perform_now @fb_post
      assert_equal(true, @fb_post.post_comments.count > 10)
    end
  end

  test "scraping execution for a post v2" do
    VCR.use_cassette("fb_scraping_watir_2") do
      count = ExtractDataComentsInBatchJob.perform_now @fb_post_v2
      assert_equal(true, @fb_post_v2.post_comments.count > 10)
    end
  end

  test "scraping execution for a post with photo" do
    VCR.use_cassette("fb_scraping_watir_3") do
      count = ExtractDataComentsInBatchJob.perform_now @fb_post_photo
      assert_equal(true, @fb_post_photo.post_comments.count > 10)
    end
  end
end
