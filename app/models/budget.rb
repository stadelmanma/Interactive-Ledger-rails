class Budget < ApplicationRecord
  has_many :budget_expenses, inverse_of: :budget, dependent: :destroy
  accepts_nested_attributes_for :budget_expenses

  validates_associated :budget_expenses
  validates :name, presence: true
end
