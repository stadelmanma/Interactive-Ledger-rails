class CreateCategoryInitializers < ActiveRecord::Migration[5.0]
  def change
    create_table :category_initializers do |t|
      t.string :pattern, null: false
      t.string :category
      t.string :subcategory
      t.timestamps
    end
  end
end
