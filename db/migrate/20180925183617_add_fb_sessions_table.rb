class AddFbSessionsTable < ActiveRecord::Migration[5.1]
  def change
    create_table :fb_sessions do |t|
      t.string :name
      t.timestamps
    end
  end
end
