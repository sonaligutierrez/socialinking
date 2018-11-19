class PostCreatorLike < ApplicationRecord
  belongs_to :facebook_user
  belongs_to :post_creator

  validates :facebook_user, :post_creator, presence: true
end
