class ExtractDataReactionsInBatchJob < ApplicationJob
  queue_as :default

  def perform(post)
    post.scraping_reactions
  end
end
