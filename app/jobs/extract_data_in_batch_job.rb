class ExtractDataInBatchJob < ApplicationJob
  queue_as :default

  def perform(post)
    count = post.scraping
    puts "Procesados: #{count} comments"
  end
end
