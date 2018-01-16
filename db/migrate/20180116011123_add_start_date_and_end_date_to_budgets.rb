class AddStartDateAndEndDateToBudgets < ActiveRecord::Migration[5.1]
  def change
    add_column :budgets, :start_date, :date
    add_column :budgets, :end_date, :date
  end
end
