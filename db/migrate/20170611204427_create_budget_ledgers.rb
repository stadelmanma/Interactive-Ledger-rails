class CreateBudgetLedgers < ActiveRecord::Migration[5.0]
  def change
    create_table :budget_ledgers do |t|
      t.references :budget, foreign_key: true
      t.references :ledger, foreign_key: true
    end
  end
end
