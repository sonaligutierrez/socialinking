class Post < ApplicationRecord
  belongs_to :post_creator
  belongs_to :account
  has_many :comments
  has_many :scraping_logs
end
