class FacebookUser < ApplicationRecord
  has_many :post_comments

  validates :fb_username, :fb_name, presence: true

  scope :created_before_24_hours, -> {where("created_at > ?", 36.hours.ago)}

  def name
    fb_username
  end

  def scraping
    start_time = DateTime.now
    post_creator = post_comments&.first&.post&.post_creator
    if post_creator
      fb_scraping = FacebookProfileScraping.new(self, post_creator.fb_user, post_creator.fb_pass, post_creator.fb_session, post_creator.proxy)

      # Login
      if fb_scraping.login
        post_creator.fb_session = fb_scraping.get_cookie_yml
        post_creator.save
        fb_scraping.process
      end
      end_time = DateTime.now
      seconds = ((end_time - start_time) * 24 * 60 * 60).to_i
      true
    else
      false
    end
  end
end
