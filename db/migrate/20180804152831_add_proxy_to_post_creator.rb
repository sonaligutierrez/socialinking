class AddProxyToPostCreator < ActiveRecord::Migration[5.1]
  def change
    add_column :post_creators, :proxy, :string
  end
end
