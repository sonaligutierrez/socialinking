class ScrapingLog < ApplicationRecord
  belongs_to :post

  def exec_time_in_hours
    exec_time.utc.strftime("%H:%M:%S")
  end
end
