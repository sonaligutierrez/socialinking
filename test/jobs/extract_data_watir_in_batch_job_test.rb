require "test_helper"

class ExtractDataWatirInBatchJobTest < ActiveJob::TestCase
  def setup
    @fb_post = posts(:watir_2)
  end
end
