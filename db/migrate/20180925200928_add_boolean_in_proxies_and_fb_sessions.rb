class AddBooleanInProxiesAndFbSessions < ActiveRecord::Migration[5.1]
  def change
  	add_column :proxies, :disabled, :boolean, :default => false
  	add_column :fb_sessions, :disabled, :boolean, :default => false
  end
end
