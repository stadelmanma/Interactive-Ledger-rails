class AddAccountToTransactions < ActiveRecord::Migration[5.0]
  def change
    add_column :transactions, :account, :string
  end
end
