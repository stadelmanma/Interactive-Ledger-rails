# Logic to handle calculation of category and weekly totals
module LedgerSummary
  extend ActiveSupport::Concern

  included do
    helper_method :generate_averages
    helper_method :generate_totals
  end

  def generate_totals(ledger, totals)
    transactions = ledger.transactions.where.not(category: 'Discover')
    data = {
      total_expenses: transactions.sum do |trans|
        trans.amount.negative? ? trans.amount : 0
      end,
      total_deposits: transactions.sum do |trans|
        trans.amount.negative? ? 0 : trans.amount
      end,
      category_totals: overall_category_toals(totals)
    }
    #
    data
  end

  def generate_averages(totals)
    # calculate weekly average in advance
    weekly_average = totals.values.map { |t| t[:week_total].to_f }
    weekly_average = weekly_average.inject(:+).to_f / totals.length
    #
    data = {
      weekly_average: weekly_average,
      category_averages: {
        # add some special logic to pull subcat from budgeted and deposits
        # it would also be good to record the number of terms in each average
      }
    }
    #
    data
  end

  def overall_category_toals(totals)
    data = Hash.new(0)
    # step over all weekly totals in the ledger
    totals.values.each do |week_total|
      # pull in totals from each category excluding budgeted items and deposits
      week_total[:category_totals].each do |key, amount|
        next if key =~ /deposit|budgeted/i
        #
        data[key] += amount.to_f
      end

      # process budgeted items and deposit using subcategory as key
      (week_total[:budgeted_expenses] + week_total[:deposits]).each do |trans|
        data[trans.subcategory] += trans.amount.to_f
      end
    end
    # return overall totals for each category
    sort_category_totals(data)
  end

  def sort_category_totals(data)
    Hash[data.to_a.sort { |a, b| b[1].abs <=> a[1].abs }]
  end
end
