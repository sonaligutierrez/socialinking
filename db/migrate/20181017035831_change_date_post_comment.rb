class ChangeDatePostComment < ActiveRecord::Migration[5.1]
  def change
    change_column :post_comments, :date, :timestamp
  end
end
