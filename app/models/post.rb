class Post < ApplicationRecord
  belongs_to :post_creator
  has_many :post_comments
  has_many :post_reactions, foreign_key: "posts_id"
  has_many :post_shared, foreign_key: "posts_id"
  has_many :scraping_logs

  validates :post_creator, :url, presence: true

  after_create :send_to_scraping_comments
  after_create :send_to_scraping_reactions
  after_create :send_to_scraping_shared

  before_create :clean_url

  attr_accessor :debug, :headless

  scope :created_before_24_hours, -> { where("created_at > ?", 36.hours.ago) }

  def scraping_comments
    start_time = DateTime.now

    fb_scraping = FacebookPostScrapingComments.new(url, post_creator.fb_user, post_creator.fb_pass, post_creator.fb_session.try(:name), "", @headless || true, @debug || false)

    count = 0

    page_info = fb_scraping.get_page_info
    if page_info
      self.title = page_info[:title]
      self.description = page_info[:description]
      self.image = page_info[:image]
      self.save
    end

    # Login
    if fb_scraping.login
      post_creator.fb_session = FbSession.new unless post_creator.fb_session
      post_creator.fb_session.name = fb_scraping.get_cookie_json
      post_creator.fb_session.save
      # begin
      fb_scraping.post_id = id
      count = fb_scraping.process
    end
    fb_scraping.close
    end_time = DateTime.now
    fb_scraping.message += "Scraping finished. "
    seconds = ((end_time - start_time) * 24 * 60 * 60).to_i
    scraping_logs.create(scraping_date: start_time, exec_time: Time.at(seconds), total_comment: count, message: fb_scraping.message)
    count
  end

  def scraping_reactions
    start_time = DateTime.now

    fb_scraping = FacebookPostScrapingReactions.new(url, post_creator.fb_user, post_creator.fb_pass, post_creator.fb_session.try(:name), "", @headless || true, @debug || false)

    count = 0

    page_info = fb_scraping.get_page_info
    if page_info
      self.title = page_info[:title]
      self.description = page_info[:description]
      self.image = page_info[:image]
      self.save
    end

    # Login
    if fb_scraping.login
      post_creator.fb_session = FbSession.new unless post_creator.fb_session
      post_creator.fb_session.name = fb_scraping.get_cookie_json
      post_creator.fb_session.save
      # begin
      fb_scraping.post_id = id
      count = fb_scraping.process
    end
    fb_scraping.close
    end_time = DateTime.now
    fb_scraping.message += "Scraping finished. "
    seconds = ((end_time - start_time) * 24 * 60 * 60).to_i
    scraping_logs.create(scraping_date: start_time, exec_time: Time.at(seconds), total_comment: count, message: fb_scraping.message)
    count
  end

  def scraping_shared
    start_time = DateTime.now

    fb_scraping = FacebookPostScrapingShared.new(url, post_creator.fb_user, post_creator.fb_pass, post_creator.fb_session.try(:name), "", @headless.nil? ? true : @headless, @debug.nil? ? false : @debug)

    count = 0

    page_info = fb_scraping.get_page_info
    if page_info
      self.title = page_info[:title]
      self.description = page_info[:description]
      self.image = page_info[:image]
      self.save
    end

    # Login
    if fb_scraping.login
      post_creator.fb_session = FbSession.new unless post_creator.fb_session
      post_creator.fb_session.name = fb_scraping.get_cookie_json
      post_creator.fb_session.save
      # begin
      fb_scraping.post_id = id
      count = fb_scraping.process
    end
    fb_scraping.close
    end_time = DateTime.now
    fb_scraping.message += "Scraping finished. "
    seconds = ((end_time - start_time) * 24 * 60 * 60).to_i
    scraping_logs.create(scraping_date: start_time, exec_time: Time.at(seconds), total_comment: count, message: fb_scraping.message)
    count
  end

  def count_comments_uncategorized
    post_comments.joins(:category).where("categories.name LIKE ?", "Uncategorized").count
  end

  def count_comments_categorized
    post_comments.joins(:category).where("categories.name NOT LIKE ?", "Uncategorized").count
  end

  def self.cant_comments(id)
    find(id).post_comments.count
  end

  def self.last_ten_posts
    joins(:post_creator).limit(10).order("post_date DESC").select(:id, :title, :post_date, "post_creators.fan_page")
  end

  def uncategorized_porcent
    if post_comments.count > 0
      (count_comments_uncategorized * 100) / post_comments.count
    else
      0
    end
  end

  def send_to_scraping_comments
    ExtractDataCommentsInBatchJob.set(wait: 1.second).perform_later self if self.get_comments
  end

  def send_to_scraping_reactions
    ExtractDataReactionsInBatchJob.set(wait: 1.second).perform_later self if self.get_reactions
  end

  def send_to_scraping_shared
    ExtractDataSharedInBatchJob.set(wait: 1.second).perform_later self if self.get_shared
  end

  private

    def clean_url
      if self.url.include?("post")
        self.url = self.url.split("?").first
      elsif self.url.include?("story_fbid")
        the_url = self.url
        self.url = the_url.split("&").first
        self.url += "&"
        self.url += the_url.split("&").second unless the_url.split("&").second.to_s.empty?
      end
    end
end
