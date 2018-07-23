class ExtractProfileDataInBatchJob < ApplicationJob
  queue_as :default

  def perform(facebook_user)
    facebook_user.scraping
  end
end
