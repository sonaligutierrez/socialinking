class RenameAcountTable < ActiveRecord::Migration[5.1]
  def self.up
    rename_table :acounts, :accounts
  end

  def self.down
    rename_table :accounts, :acounts
  end
end
