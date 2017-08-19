# Logic to handle calculation of category and weekly totals
module TransactionTotals
  extend ActiveSupport::Concern

  included do
    helper_method :create_totals_hash
    helper_method :totals_column_names
  end

  # Column names used to report totals in ledger#show
  def totals_column_names
    %w[week_total total_deficit category_totals]
  end

  # Returns a hash where the key's are indicies to output week totals
  # the rowspan is set so totals cells will span an entire week
  def create_totals_hash(transactions)
    totals = {}
    week_total = nil
    #
    # loop over transactions
    transactions.each_with_index do |transaction, i|
      #
      # create new entry for each week
      if new_week?(transactions, i)
        week_total = WeekTotal.new(transaction.date)
        totals[i] = week_total
      end
      week_total << transaction
    end
    # set total deficit values for each total
    calculate_total_deficit(totals)
    totals
  end

  private

  # test if a date pair crosses a week boundary
  def new_week?(transactions, i)
    # return early if at beginning or end of list
    return true if i.zero?
    return false if i == transactions.length
    #
    curr_wk = transactions[i][:date].strftime('%U').to_i
    test_wk = transactions[i - 1][:date].strftime('%U').to_i

    # return true if week numbers are different
    curr_wk != test_wk
  end

  def calculate_total_deficit(totals)
    totals.values.inject(0) do |total_deficit, week|
      week.total_deficit += total_deficit + week.total
    end
  end
end
