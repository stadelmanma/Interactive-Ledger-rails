# manages data for a collection of transactions over a week
class WeekTotal
  attr_accessor :total_deficit
  attr_reader :date_range

  # returns the number of transaction rows that need to be spanned
  def rowspan
    @transactions.length + @skipped_transactions.length
  end

  # returns all deposits
  def deposits
    @transactions.find_all { |trans| trans.category.match?(/deposit/i) }
  end

  # returns all 'budgeted' items
  def budgeted_expenses
    @transactions.find_all { |trans| trans.category.match?(/budgeted/i) }
  end

  # returns the total dollar amount of a single category in the totals hash
  def category_total(category)
    pat = /#{category}/i
    @transactions.find_all { |t| t.category.match?(pat) }.sum(&:amount)
  end

  def categories
    @transactions.map(&:category).uniq
  end

  # returns the total amount spent in a week skipping budgeted items and
  # deposits
  def total
    @transactions.sum do |trans|
      trans.category.match?(/budgeted|deposit/i) ? 0.0 : trans.amount
    end
  end

  # adds a transaction to the week total
  def <<(transaction)
    # add the transaction to appropriate array
    if skip_transaction?(transaction)
      @skipped_transactions << transaction
      return
    else
      @transactions << transaction
    end

    # add transaction to a category
    category = transaction.category.blank? ? 'UNKNOWN' : transaction.category
    @category_totals[category] << transaction
  end

  private

  def initialize(date)
    @date_range = week_date_range(date)
    @total_deficit = 0.0
    @category_totals = Hash.new { |hash, key| hash[key] = [] }
    @transactions = []
    @skipped_transactions = []
  end

  def week_date_range(date)
    [date.beginning_of_week, date.end_of_week]
  end

  # Returns 'true' is criteria are met to exclude the transaction from
  # incrementing the totals hash
  def skip_transaction?(transaction)
    if transaction.amount.blank?
      true
    elsif transaction.category =~ /discover/i
      true
    end
  end
end
