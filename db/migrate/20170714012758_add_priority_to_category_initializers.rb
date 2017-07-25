class AddPriorityToCategoryInitializers < ActiveRecord::Migration[5.0]
  def change
    add_column :category_initializers, :priority, :integer, default: 0
  end
end
