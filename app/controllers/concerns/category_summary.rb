# Manages a single set of data for a single category across a range of
# transactions
class CategorySummary
  attr_accessor :name, :nweeks
  attr_reader :transactions

  def initialize(name, transactions = [], nweeks = 0)
    @name = name
    @transactions = transactions.find_all { |t| t.category.match?(/#{name}/i) }
    @nweeks = nweeks
  end

  def <<(transaction)
    @transactions << transaction
  end

  def sum
    @transactions.sum(&:amount)
  end

  def average(counts = nil)
    counts = @transactions.length unless counts.nil?
    sum / counts
  end

  def average_per_week
    average(@nweeks)
  end
end
