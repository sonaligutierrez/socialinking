class RemoveProxyAndFbSessionInPostCreator < ActiveRecord::Migration[5.1]
  def change
    remove_column :post_creators, :proxy
    remove_column :post_creators, :fb_session
  end
end
