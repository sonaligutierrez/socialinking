class FacebookUser < ApplicationRecord
  has_many :comments

  validates :fb_username, :fb_name, presence: true
end
