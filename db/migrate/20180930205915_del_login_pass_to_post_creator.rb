class DelLoginPassToPostCreator < ActiveRecord::Migration[5.1]
  def change
    remove_column :post_creators, :fb_user
    remove_column :post_creators, :fb_pass
  end
end
