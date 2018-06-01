class AddFacebookCredentialsToPostCreator < ActiveRecord::Migration[5.1]
  def change
    add_column :post_creators, :fb_user, :string
    add_column :post_creators, :fb_pass, :string
    add_column :post_creators, :fb_session, :string
  end
end
