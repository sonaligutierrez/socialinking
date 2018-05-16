class CreateFacebookUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :facebook_users do |t|
      t.string :fb_username
      t.string :fb_name
      t.string :fb_avatar

      t.timestamps
    end
  end
end
