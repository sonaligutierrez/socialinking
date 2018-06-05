class ExtractDataInBatchJob < ApplicationJob
  queue_as :default

  def perform(*args)
    sleep(5)
    puts "Do something later #{args[0]}"
  end
end
