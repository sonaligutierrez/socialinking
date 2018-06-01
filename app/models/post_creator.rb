class PostCreator < ApplicationRecord
  has_many :posts
  belongs_to :account

  def name
    fan_page
  end
end
