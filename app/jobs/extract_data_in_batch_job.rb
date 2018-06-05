class ExtractDataInBatchJob < ApplicationJob
  queue_as :default

  def perform(*args)
    puts "Do something later #{args[0]}"
  end
end
