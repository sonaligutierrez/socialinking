class AddDateCommentToComment < ActiveRecord::Migration[5.1]
  def change
    add_column :comments, :date_comment, :string
  end
end
