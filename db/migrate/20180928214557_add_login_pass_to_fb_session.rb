class AddLoginPassToFbSession < ActiveRecord::Migration[5.1]
  def change
    add_column :fb_sessions, :login, :string
    add_column :fb_sessions, :pass, :string
  end
end
