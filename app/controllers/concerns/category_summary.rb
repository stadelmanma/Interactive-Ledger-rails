# Manages a single set of data for a single category across a range of
# transactions
class CategorySummary
  attr_accessor :name
  attr_reader :transactions

  def initialize(name, transactions = [])
    @name = name
    @transactions = transactions.find_all { |t| t.category.match?(/#{name}/i) }
  end

  def <<(transaction)
    @transactions << transaction
  end

  def sum
    @transactions.sum(&:amount)
  end

  def average(counts = nil)
    counts = @transactions.length unless counts
    sum / counts
  end
end
