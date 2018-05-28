class PostCreator < ApplicationRecord
  has_many :posts
  belongs_to :account
end
