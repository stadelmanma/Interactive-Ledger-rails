class AddIndicesToKeyColumns < ActiveRecord::Migration[5.1]
  def change
    add_index :category_exclusions, :excluded_from, type: :fulltext
    add_index :transactions, :category, type: :fulltext
  end
end
