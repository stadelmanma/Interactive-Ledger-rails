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
  def create_totals_hash(ledger)
    totals = { 0 => { total_deficit: 0 } }
    current_total = 0
    #
    # loop over all transactions
    ledger.transactions.each_with_index do |transaction, i|
      #
      # create new entry for each week
      if new_week?(ledger.transactions, i)
        initialize_week_total(totals, current_total, i)
        current_total = i
      end
      update_totals(totals, current_total, transaction)
    end
    #
    format_totals(totals)
  end

  # Increment the provided totals hash with transaction data
  def update_totals(totals, current_total, transaction)
    totals[current_total][:rowspan] += 1

    # preventing totals from being incremented in some cases
    return if skip_transaction?(transaction)

    # increment totals
    update_week_total(transaction, totals[current_total])
    update_category_totals(transaction, totals[current_total])
  end

  def update_week_total(transaction, totals)
    totals[:week_total] += transaction.amount
    totals[:total_deficit] += transaction.amount
  end

  def update_category_totals(transaction, totals)
    if totals[:category_totals][transaction.category]
      totals[:category_totals][transaction.category] += transaction.amount
    else
      totals[:category_totals][transaction.category] = transaction.amount
    end
  end

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

  # Sets the inital values for weekly totals
  def initialize_week_total(totals, current_total, i)
    totals[i] = {
      rowspan: 0,
      week_total: 0,
      total_deficit: totals[current_total][:total_deficit],
      category_totals: {}
    }
  end

  # Returns 'true' is criteria are met to exclude the transaction from
  # incrementing the totals hash
  def skip_transaction?(transaction)
    transaction.category =~ /discover/i ? true : false
  end

  # Formats the numbers in the totals hash for ledger display
  def format_totals(totals)
    totals.each do |key, value|
      totals[key] = if value.class == Hash
                      format_totals(value)
                    else
                      Transaction.display_number(value)
                    end
    end
    #
    totals
  end
end
