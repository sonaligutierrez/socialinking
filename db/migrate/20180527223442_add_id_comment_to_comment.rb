class AddIdCommentToComment < ActiveRecord::Migration[5.1]
  def change
    add_column :comments, :id_comment, :string
    add_column :comments, :reactions, :string
    add_column :comments, :reactions_description, :string
    add_column :comments, :responses, :string
  end
end
