class Comment < ApplicationRecord
  belongs_to :facebook_user
  belongs_to :post
  belongs_to :category
end
