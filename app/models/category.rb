class Category < ApplicationRecord
  has_many :post_comments
  belongs_to :account

  validates :name, presence: true

  def self.content_select
    array_cat = []
    array_cat.push([" "])
    array_cat.push(["TODO", 0])
    all.map { |c| array_cat.push([c.try(:name).nil? ? "" : c.try(:name).upcase, c.id]) }
    array_cat
  end
end
