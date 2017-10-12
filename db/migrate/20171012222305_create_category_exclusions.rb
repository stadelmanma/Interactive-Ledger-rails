class CreateCategoryExclusions < ActiveRecord::Migration[5.0]
  def change
    create_table :category_exclusions do |t|
      t.references :ledger, foreign_key: true, index: true
      t.string :category, null: false
      t.string :excluded_from, null: false

      t.timestamps
    end
  end
end
