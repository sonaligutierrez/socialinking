class AddAccountToCategory < ActiveRecord::Migration[5.1]
  def change
    add_reference :categories, :account, foreign_key: true

    reversible do |dir|
      dir.up do
        Category.update_all(account_id: Account.last.id)
      end
    end
  end
end
