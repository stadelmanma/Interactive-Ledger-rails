# Uses a pattern to test the description and set a default category
class CategoryInitializer < ApplicationRecord
  validates :pattern, presence: true
  validates :category, presence: true
end
