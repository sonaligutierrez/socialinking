class AddAccountToCategory < ActiveRecord::Migration[5.1]
  def change
    add_reference :categories, :account, foreign_key: true

    reversible do |dir|
      dir.up do
        account = Account.last
        Category.update_all(account_id: account.id) if account
      end
    end
  end
end
