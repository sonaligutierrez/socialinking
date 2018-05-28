class AddAccountToPostCreator < ActiveRecord::Migration[5.1]
  def change
    add_reference :post_creators, :account, foreign_key: true
    remove_reference :posts, :account
  end
end
