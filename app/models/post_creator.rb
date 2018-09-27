class PostCreator < ApplicationRecord
  has_many :posts
  belongs_to :account
  belongs_to :proxy, optional: true
  belongs_to :fb_session, optional: true

  before_validation :check_to_clean_session
  after_create :assign_avatar


  def check_to_clean_session
    if self.changed_attributes.keys.include?("fb_user") || self.changed_attributes.keys.include?("fb_pass")
      self.fb_session_id = nil
    end
  end

  def name
    fan_page
  end

  def assign_avatar
    fb_scraping = FacebookProfileScraping.new(self, self.fb_user, self.fb_pass, self.fb_session.try(:name), self.proxy.try(:name))
    fb_scraping.get_post_creator_avatar
  end

  def generate_cookie
    post_creator = self
    var_json = "--- !ruby/object:Mechanize::CookieJar\n"
    var_json += "store: !ruby/object:HTTP::CookieJar::HashStore\n"
    var_json += "\ \ mon_owner: \n"
    var_json += "\ \ mon_count: 0\n"
    var_json += "\ \ mon_mutex: !ruby/object:Thread::Mutex {}\n"
    var_json += "\ \ logger: \n"
    var_json += "\ \ gc_threshold: 150\n"
    var_json += "\ \ jar:\n"
    var_json += "\ \ \ \ facebook.com:\n"
    var_json += "\ \ \ \ \ \ \"/\":\n"

    JSON.parse(post_creator.cookie_info).each do |cook|
      # puts cook[:name]
      var_json += "\ \ \ \ \ \ \ \ #{cook['name']}: !ruby/object:HTTP::Cookie\n"
      var_json += "\ \ \ \ \ \ \ \ \ \ domain: #{cook['domain']}\n"
      var_json += "\ \ \ \ \ \ \ \ \ \ hostOnly: #{cook['hostOnly']}\n"
      var_json += "\ \ \ \ \ \ \ \ \ \ httpOnly: #{cook['httpOnly']}\n"
      var_json += "\ \ \ \ \ \ \ \ \ \ name: #{cook['name']}\n"
      var_json += "\ \ \ \ \ \ \ \ \ \ path: #{cook['path']}\n"
      var_json += "\ \ \ \ \ \ \ \ \ \ sameSite: #{cook['sameSite']}\n"
      var_json += "\ \ \ \ \ \ \ \ \ \ secure: #{cook['secure']}\n"
      var_json += "\ \ \ \ \ \ \ \ \ \ session: #{cook['session']}\n"
      var_json += "\ \ \ \ \ \ \ \ \ \ storeId: #{cook['storeId']}\n"
      var_json += "\ \ \ \ \ \ \ \ \ \ value: \"#{cook['value']}\"\n"
    end
    var_json += "\ \ gc_index: 18"
    fbs = FbSession.new_session var_json
    post_creator.fb_session_id = fbs.id
    post_creator.save!
  end
end
