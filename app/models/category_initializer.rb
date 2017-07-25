# Uses a pattern to test the description and set a default category
class CategoryInitializer < ApplicationRecord
  before_validation do
    self.pattern = pattern.strip if attribute_present?('pattern')
  end

  validates :pattern, presence: true
  validate :check_pattern
  validates :category, presence: true

  attr_accessor :_destroy

  def self.find_initializer(description)
    CategoryInitializer.all.order(priority: :desc).detect do |ci|
      description =~ Regexp.new(ci.pattern, true)
    end
  end

  private

  def check_pattern
    Regexp.new(pattern)
  rescue RegexpError => e
    errors.add(:pattern, e.message)
  end
end
