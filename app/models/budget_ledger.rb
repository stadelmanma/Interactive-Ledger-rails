# A join table to manage the relationship between budgets and ledgers as
# the two are inherently independent
class BudgetLedger < ApplicationRecord
  belongs_to :budget
  belongs_to :ledger
end
