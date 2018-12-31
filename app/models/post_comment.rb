class PostComment < ApplicationRecord
  belongs_to :facebook_user
  belongs_to :post
  belongs_to :category

  validates :comment, :id_comment, :facebook_user, :post, presence: true

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
end
