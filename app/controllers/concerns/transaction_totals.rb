module TransactionTotals
  extend ActiveSupport::Concern

  included do
    helper_method :create_totals_hash
    helper_method :totals_column_names
  end

  def totals_column_names
    [
      'week_total',
      'total_deficit',
      'category_totals'
    ]
  end

  def create_totals_hash(ledger)
    totals = {0 => {total_deficit: 0}}
    cur_total = 0
    #
    # loop over all transactions
    ledger.transactions.each_with_index do |transaction, i|
      #
      # create new entry for each week
      if new_week?(ledger.transactions, i)
        totals[i] = {
          rowspan: 0,
          week_total: 0,
          total_deficit: totals[cur_total][:total_deficit],
          category_totals: {}
        }
        cur_total = i
      end
      totals[cur_total][:rowspan] += 1
      #
      # preventing totals from being incremented in some cases
      next if skip_transaction?(transaction)
      #
      # increment totals
      update_week_total(transaction, totals[cur_total])
      update_category_totals(transaction, totals[cur_total])
    end
    #
    format_totals(totals)
    return totals
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
    return true if i == 0
    return false if i == transactions.length
    #
    curr_wk = transactions[i][:date].strftime("%U").to_i
    test_wk = transactions[i - 1][:date].strftime("%U").to_i
    # return true if week numbers are different
    return curr_wk != test_wk
  end

  def skip_transaction?(transaction)
    return transaction.category.match(/discover/i) ? true : false
  end

  def format_totals(totals)
    totals.each do |key, value|
      if value.class == Hash
        totals[key] = format_totals(value)
      end
      totals[key] = Transaction.display_number(value)
    end
    #
    return totals
  end
end
