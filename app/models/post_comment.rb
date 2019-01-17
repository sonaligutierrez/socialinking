class PostComment < ApplicationRecord
  belongs_to :facebook_user
  belongs_to :post
  belongs_to :category

  validates :comment, :id_comment, :facebook_user, :post, presence: true

  attr_accessor :keywords, :post_creator_id, :date_from, :date_to

  def self.categorized_vs_uncategorized
    uncategorized = joins(:category).where("categories.name not like '%Uncategorized%'").count
    categorized = joins(:category).where("categories.name like '%Uncategorized%'").count
    hash_coms = Hash.new
    hash_coms.merge!("Categorizados" => categorized)
    hash_coms.merge!("Sin Categorizar" => uncategorized)
    hash_coms
  end

  def self.cant_for_category
    pc = joins(:category).select("categories.name as name, post_comments.category_id number").group("name, number").order("name desc")
    hash_coms = Hash.new
    pc.each do |c|
      hash_coms.merge!(c.name => c.number)
    end
    hash_coms
  end

  def self.categorized
    joins(:category).where("categories.name like '%Uncategorized%'").count
 end

  def self.uncategorized
    joins(:category).where("categories.name not like '%Uncategorized%'").count
 end

  def self.search(params)
    result = PostComment.joins(:post)
    sql = ""
    if params[:keywords].present? && !result.nil?
      values = params[:keywords].split("-")
      values.each do |v|
        if sql.blank?
          sql = "post_comments.comment LIKE '%#{v}%'"
        else
          sql = "#{sql} or post_comments.comment LIKE '%#{v}%'"
        end
      end
    end
    if params[:post_creator_id].present? && !result.nil?
      if sql.blank?
        sql = "posts.post_creator_id = #{params[:post_creator_id]}"
      else
        sql = "#{sql} and posts.post_creator_id = #{params[:post_creator_id]}"
      end
    end
    if params[:post_id].present? && !result.nil?
      if sql.blank?
        sql = "post_comments.post_id = #{params[:post_id]}"
      else
        sql = "#{sql} and post_comments.post_id = #{params[:post_id]}"
      end
    end
    if (params[:date_from].present? && !params[:date_to].present?) && !result.nil?
      if sql.blank?
        sql = "post_comments.date = '#{params[:date_from]}'"
      else
        sql = "#{sql} and post_comments.date = '#{params[:date_from]}'"
      end
    end
    if (!params[:date_from].present? && params[:date_to].present?) && !result.nil?
      if sql.blank?
        sql = "post_comments.date = '#{params[:date_to]}'"
      else
        sql = "#{sql} and post_comments.date = '#{params[:date_to]}'"
      end
    end
    if (params[:date_from].present? && params[:date_to].present?) && !result.nil?
      if sql.blank?
        sql = "post_comments.date >= '#{params[:date_from]}' and post_comments.date <= '#{params[:date_to]}'"
      else
        sql = "#{sql} and post_comments.date >= '#{params[:date_from]}'' and post_comments.date <= '#{params[:date_to]}'"
      end
    end
    if !result.nil?
      categories = params[:categories]
      categories.each do |k, v|
        if v.to_i == 1
          id = k.split("-")[1].to_i
          if sql.blank?
            sql = "post_comments.category_id = #{id}"
          else
            sql = "#{sql} or post_comments.category_id = #{id}"
          end
        end
      end
    end
    result = result.where(sql)
    result
   end
end
