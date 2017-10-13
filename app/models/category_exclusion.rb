# Used to filter ledger transactions based on categories
class CategoryExclusion < ApplicationRecord
  belongs_to :ledger, inverse_of: :category_exclusions
end
