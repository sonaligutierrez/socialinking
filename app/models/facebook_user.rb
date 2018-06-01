class FacebookUser < ApplicationRecord
  has_many :post_comments

  validates :fb_username, :fb_name, presence: true

  def name
    fb_username
  end
end
