class AddImageToPost < ActiveRecord::Migration[5.1]
  def change
    add_column :posts, :description, :string
    add_column :posts, :image, :string
  end
end
