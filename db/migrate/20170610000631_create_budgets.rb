class CreateBudgets < ActiveRecord::Migration[5.0]
  def change
    create_table :budgets do |t|
      t.date :date
      t.string :description
      t.float :amount
      t.text :comments
      t.timestamps
    end
  end
end
