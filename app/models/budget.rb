# Combines planned expenses with actual transactions recorded
class Budget < ApplicationRecord
  has_many :budget_expenses, inverse_of: :budget, dependent: :destroy
  accepts_nested_attributes_for :budget_expenses

  has_many :budget_ledgers
  has_many :ledgers, through: :budget_ledgers

  validates_associated :budget_expenses
  validates :name, presence: true
end
