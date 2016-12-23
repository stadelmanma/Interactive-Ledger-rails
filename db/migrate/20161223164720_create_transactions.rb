class CreateTransactions < ActiveRecord::Migration[5.0]
  def change
    create_table :transactions do |t|
      t.references :ledger, foreign_key: true
      t.date :date
      t.string :description
      t.float :amount
      t.boolean :validated
      t.string :category
      t.string :subcategory
      t.text :comments

      t.timestamps
    end
  end
end
