class AddColumnInPostCreators < ActiveRecord::Migration[5.1]
  def change
    add_column :post_creators, :cookie_info, :string
  end
end
