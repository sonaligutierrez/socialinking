class Category < ApplicationRecord
  has_many :post_comments
end
