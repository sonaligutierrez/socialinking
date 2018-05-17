class Post < ApplicationRecord
  belongs_to :post_creators
  belongs_to :users
  has_many :commentaries
  has_many :scraping_logs
end
