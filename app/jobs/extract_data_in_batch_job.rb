class ExtractDataInBatchJob < ApplicationJob
  queue_as :default

  def perform(post)
    post.scraping
  end
end
