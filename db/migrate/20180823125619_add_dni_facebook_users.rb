class AddDniFacebookUsers < ActiveRecord::Migration[5.1]
  def change
  	add_column :facebook_users, :dni, :string
  end
end
