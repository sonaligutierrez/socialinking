class AddPostCreatorRelations < ActiveRecord::Migration[5.1]
  def change
  	add_reference :post_creators, :fb_session, foreign_key: true
  	add_reference :post_creators, :proxy, foreign_key: true
  end
end
