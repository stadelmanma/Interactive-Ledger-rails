# Manages a single set of data for a single category across a range of
# transactions
class CategorySummary
  attr_accessor :name, :nweeks
  attr_reader :transactions

  # sorts the array of summaries by the chosen method
  def self.sort_summaries_by(data, meth)
    Hash[data.to_a.sort { |a, b| b[1].send(meth).abs <=> a[1].send(meth).abs }]
  end

  def initialize(name, transactions = [], nweeks = 0)
    @name = name
    @transactions = transactions.find_all { |t| t.category.match?(pattern) }
    @nweeks = nweeks
  end

  def <<(transaction)
    @transactions << transaction
  end

  def merge(other)
    self.class.new(name, (@transactions + other.transactions).uniq, @nweeks)
  end

  def sum
    @transactions.sum(&:amount)
  end

  def average(counts = nil)
    counts = @transactions.length if counts.nil?
    sum / counts
  end

  def average_per_week
    average(@nweeks)
  end

  def subcategory_summaries
    data = @transactions.map(&:subcategory).uniq.map do |name|
      [name, SubcategorySummary.new(name, @transactions, @nweeks)]
    end
    #
    Hash[data]
  end

  private

  def pattern
    /^#{name}$/i
  end
end

# A summary by subcategory with the same API as the CategorySummary class
class SubcategorySummary < CategorySummary
  def initialize(name, transactions, nweeks)
    super(name, [], nweeks)
    @transactions = transactions.find_all { |t| t.subcategory.match?(pattern) }
  end

  def subcategory_summaries
    raise NoMethodError, 'This method is not supported'
  end
end
