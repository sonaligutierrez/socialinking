class CreatePostCreators < ActiveRecord::Migration[5.1]
  def change
    create_table :post_creators do |t|
      t.string :fan_page
      t.string :url
      t.string :avatar

      t.timestamps
    end
  end
end
