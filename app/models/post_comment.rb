class PostComment < ApplicationRecord
  belongs_to :facebook_user
  belongs_to :post
  belongs_to :category

  validates :comment, :id_comment, :facebook_user, :post, presence: true
end
