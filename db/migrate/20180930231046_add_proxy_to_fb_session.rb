class AddProxyToFbSession < ActiveRecord::Migration[5.1]
  def change
    add_reference :fb_sessions, :proxy, foreign_key: true
  end
end
