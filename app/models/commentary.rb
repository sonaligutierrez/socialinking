class Commentary < ApplicationRecord
  belongs_to :facebook_users
  belongs_to :posts
end
