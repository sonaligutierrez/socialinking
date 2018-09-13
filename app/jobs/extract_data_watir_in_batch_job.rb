class ExtractDataWatirInBatchJob < ApplicationJob
  queue_as :default

  def perform(post)
    post.scraping_watir
  end
end
