class PostReaction < ApplicationRecord
  belongs_to :facebook_user, foreign_key: "facebook_users_id"
  belongs_to :post, foreign_key: "posts_id"

  def reaction_icon
  end

  def image_reaction
    case self.reaction
    when "_3j7l"
      "like.png"
    when "_3j7q"
      "angry.png"
    when "_3j7m"
      "love.png"
    when "_3j7r"
      "sad.png"
    when "_3j7n"
      "sorprende.png"
    when "_3j7o"
      "fun.png"
    end
  end
end
