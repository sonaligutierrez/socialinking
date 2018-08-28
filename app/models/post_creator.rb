class PostCreator < ApplicationRecord
  has_many :posts
  belongs_to :account

  before_validation :check_to_clean_session
  after_create :assign_avatar


  def check_to_clean_session
    if self.changed_attributes.keys.include?("fb_user") || self.changed_attributes.keys.include?("fb_pass")
      self.fb_session = ""
    end
  end

  def name
    fan_page
  end

  def assign_avatar
    fb_scraping = FacebookProfileScraping.new(self, self.fb_user, self.fb_pass, self.fb_session, self.proxy)
    if fb_scraping.login
      fb_scraping.get_post_creator_avatar
    end
  end
end
