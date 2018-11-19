class ExtractDataSharedInBatchJob < ApplicationJob
  queue_as :default

  def perform(post)
    post.scraping_shared
  end
end
