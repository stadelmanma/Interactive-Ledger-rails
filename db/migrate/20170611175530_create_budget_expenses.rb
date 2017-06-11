class CreateBudgetExpenses < ActiveRecord::Migration[5.0]
  def change
    create_table :budget_expenses do |t|
      t.date :date
      t.string :description
      t.float :amount
      t.text :comments
      t.integer :budget_id
      t.references :budget, foreign_key: true

      t.timestamps
    end

    add_column :budgets, :name, :string
    remove_column :budgets, :date
    remove_column :budgets, :amount
    remove_column :budgets, :comments
  end
end
