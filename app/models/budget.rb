# Combines planned expenses with actual transactions recorded
class Budget < ApplicationRecord
  has_many :budget_expenses, inverse_of: :budget, dependent: :destroy
  accepts_nested_attributes_for :budget_expenses, allow_destroy: true,
                                                  reject_if: :all_blank

  has_many :budget_ledgers
  has_many :ledgers, through: :budget_ledgers
  accepts_nested_attributes_for :budget_ledgers, allow_destroy: true,
                                                 reject_if: :all_blank

  validates :name, presence: true
  validates_associated :budget_expenses
end
