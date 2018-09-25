class Post < ApplicationRecord
  belongs_to :post_creator
  has_many :post_comments
  has_many :scraping_logs

  validates :post_creator, :url, presence: true

  after_create :send_to_scraping

  attr_accessor :debug, :headless

  scope :created_before_24_hours, -> { where("created_at > ?", 36.hours.ago) }

  def scraping
    start_time = DateTime.now
    post_creator.generate_cookie if post_creator.fb_session.try(:name).to_s.empty? && !post_creator.cookie_info.to_s.empty?
    fb_scraping = FacebookPostScraping.new(url, post_creator.fb_user, post_creator.fb_pass, post_creator.fb_session.try(:name), post_creator.proxy.try(:name))

    fb_scraping.debug = true if @debug
    count = 0
    # Login
    if fb_scraping.login
      fbs = FbSession.new_session fb_scraping.get_cookie_yml
      post_creator.fb_session_id = fbs.id
      post_creator.save
      fb_scraping.process
      fb_scraping.comments.each do |comment|
        fb_user = FacebookUser.where(fb_username: comment[1][:url_profile]).first_or_create(fb_name: comment[1][:user])
        if fb_user
          the_comment = PostComment.find_by_id_comment(comment[0])
          if the_comment
            the_comment.update(date_comment: comment[1][:date_comment], reactions: comment[1][:reactions], reactions_description: comment[1][:reactions_description], responses: comment[1][:responses])
          else
            the_comment = PostComment.create(post_id: id, facebook_user_id: fb_user.id, id_comment: comment[0], date_comment: comment[1][:date_comment], reactions: comment[1][:reactions], reactions_description: comment[1][:reactions_description], responses: comment[1][:responses], category_id: Category.find_by_name("Uncategorized").id, comment: comment[1][:comment])
          end
          count += 1 if the_comment
        end
      end
    end
    page_info = fb_scraping.get_page_info
    if page_info
      self.title = page_info[:title]
      self.description = page_info[:description]
      self.image = page_info[:image]
      self.save
    end
    end_time = DateTime.now
    seconds = ((end_time - start_time) * 24 * 60 * 60).to_i
    scraping_logs.create(scraping_date: start_time, exec_time: Time.at(seconds), total_comment: count)
    count
  end

  def scraping_watir
    start_time = DateTime.now

    fb_scraping = FacebookPostScrapingWatir.new(url, post_creator.fb_user, post_creator.fb_pass, post_creator.fb_session.try(:name), "", true, @debug ? @debug : false)

    count = 0
    # Login
    if fb_scraping.login
      fbs = FbSession.new_session fb_scraping.get_cookie_json
      post_creator.fb_session_id = fbs.id
      post_creator.save
      # begin
      fb_scraping.process
      # rescue Exception => e
      #   puts e.message
      #   fb_scraping.close
      # end
      fb_scraping.comments.each do |comment|
        fb_user = FacebookUser.where(fb_username: comment[:url_profile]).first_or_create(fb_name: comment[:user])
        if fb_user
          the_comment = PostComment.find_by_id_comment(comment[:id_comment])
          if the_comment
            the_comment.update(date_comment: comment[:date_comment], reactions: comment[:reactions], reactions_description: comment[:reactions_description], responses: comment[:responses])
          else
            the_comment = PostComment.create(post_id: id, facebook_user_id: fb_user.id, id_comment: comment[:id_comment], date_comment: comment[:date_comment], reactions: comment[:reactions], reactions_description: comment[:reactions_description], responses: comment[:responses], category_id: Category.find_by_name("Uncategorized").id, comment: comment[:comment])
          end
          count += 1 if the_comment
        end
      end
    end
    fb_scraping.close
    page_info = fb_scraping.get_page_info
    if page_info
      self.title = page_info[:title]
      self.description = page_info[:description]
      self.image = page_info[:image]
      self.save
    end
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

  private
    def send_to_scraping
      ExtractDataInBatchJob.set(wait: 1.second).perform_later self
    end
end
