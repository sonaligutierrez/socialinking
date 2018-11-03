class PostReaction < ApplicationRecord
    belongs_to :facebook_user, foreign_key: "facebook_users_id"
    belongs_to :post, foreign_key: "posts_id"

end
