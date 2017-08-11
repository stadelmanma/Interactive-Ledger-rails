class AddInitialBalanceToBudgets < ActiveRecord::Migration[5.0]
  def change
    add_column :budgets, :initial_balance, :float, default: 0
  end
end
