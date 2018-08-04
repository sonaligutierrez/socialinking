class PostCreator < ApplicationRecord
  has_many :posts
  belongs_to :account

  before_validation :check_to_clean_session

  def check_to_clean_session
    if self.changed_attributes.keys.include?("fb_user") || self.changed_attributes.keys.include?("fb_pass")
      self.fb_session = ""
    end
  end

  def name
    fan_page
  end
end
