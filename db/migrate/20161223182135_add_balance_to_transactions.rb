class AddBalanceToTransactions < ActiveRecord::Migration[5.0]
  def change
    add_column :transactions, :balance, :float
  end
end
