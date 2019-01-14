class PostCreator < ApplicationRecord
  has_many :posts
  has_many :post_comments, through: :posts
  has_many :post_reactions, through: :posts
  has_many :post_shared, through: :posts


  belongs_to :account
  belongs_to :fb_session, optional: true

  before_validation :check_to_clean_session
  after_create :assign_avatar

  def fb_user
    return fb_session.login if fb_session
    nil
  end

  def fb_pass
    return fb_session.pass if fb_session
    nil
  end

  def proxy
    return fb_session.try(:proxy).name if fb_session.try(:proxy)
    nil
  end

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

  def self.search(channel, column_order, type_order)
    results = PostCreator.all
    if column_order.present?
      if column_order.to_i == 1
        results = PostCreator.joins("LEFT JOIN posts ON posts.post_creator_id = post_creators.id").select("post_creators.id, post_creators.fan_page, post_creators.url,
        post_creators.avatar, post_creators.created_at, post_creators.updated_at, post_creators.account_id,
        post_creators.cookie_info, post_creators.fb_session_id, post_creators.proxy_id,post_creators.get_likes,
        post_creators.fb_page_session,COUNT (posts.id) as count").group("post_creators.id, post_creators.fan_page,
        post_creators.url, post_creators.avatar, post_creators.created_at, post_creators.updated_at,
        post_creators.account_id, post_creators.cookie_info, post_creators.fb_session_id, post_creators.proxy_id,
        post_creators.get_likes, post_creators.fb_page_session").order("count desc")
      else
        results = results.order("#{column_order.to_sym} #{type_order}")
      end
    end
    results
  end
end
