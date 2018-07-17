class Account < ApplicationRecord
  has_many :post_creator
  has_many :categories
end
