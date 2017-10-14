class AddForeignKeysToTables < ActiveRecord::Migration[5.1]
  def change
    add_foreign_key 'transactions', 'ledgers'
    add_foreign_key 'transactions', 'ledger_uploads'
  end
end
