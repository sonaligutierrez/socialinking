class ExtractDataCommentsInBatchJob < ApplicationJob
  queue_as :default

  def perform(post)
    post.scraping_comments
  end
end
