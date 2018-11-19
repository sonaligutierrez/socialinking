class AddColumnsToPost < ActiveRecord::Migration[5.1]
  def change
    add_column :posts, :get_comments, :boolean, default: false
    add_column :posts, :get_reactions, :boolean, default: false
    add_column :posts, :get_shared, :boolean, default: false

    add_column :post_creators, :get_likes, :boolean, default: false
    add_column :post_creators, :fb_page_session, :integer
  end
end
