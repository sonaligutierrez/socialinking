class Category < ApplicationRecord
  has_many :post_comments
  belongs_to :account

  validates :name, presence: true
end
