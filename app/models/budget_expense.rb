# Records a single known expense to be listed in a budget
class BudgetExpense < ApplicationRecord
  belongs_to :budget
end
