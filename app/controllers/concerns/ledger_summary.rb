# Logic to handle calculation of category and weekly totals
module LedgerSummary
  extend ActiveSupport::Concern

  included do
    helper_method :generate_totals
  end

  def generate_totals(ledger, totals)
    nweeks = number_of_weeks(ledger)
    transactions = ledger.transactions.where.not(category: 'Discover')
    deposits = CategorySummary.new('Deposit', transactions, nweeks)
    #
    {
      total_expenses: transactions.sum do |trans|
        trans.category.match?(/^deposit$/i) ? 0.0 : trans.amount
      end,
      expense_summaries: expense_summaries(transactions, nweeks),
      #
      total_deposits: deposits.sum,
      deposit_summaries: deposits.subcategory_summaries,
      #
      weekly_average: totals.values.map(&:total).inject(:+) / totals.length,
      week_averaged_deposits: deposits.average_per_week
    }
  end

  private

  def number_of_weeks(ledger)
    st_wk = ledger.transactions.order(date: :asc).first.date.beginning_of_week
    en_wk = ledger.transactions.order(date: :asc).last.date.beginning_of_week
    ((en_wk - st_wk) / 7).to_i
  end

  # genate category summaries, using subcategory for deposits and budgeted items
  def expense_summaries(transactions, nweeks)
    categories = transactions.distinct(:category).pluck(:category)
    data = categories.map do |category|
      [category, CategorySummary.new(category, transactions, nweeks)]
    end
    data = Hash[data]
    # pull out budgeted items by subcategory and remove deposits
    merge_sub_cats(data, data.delete('Budgeted'))
    data.delete('Deposit')
    #
    data
  end

  def merge_sub_cats(data, summary)
    subcat_data = summary.subcategory_summaries
    data.merge!(subcat_data) do |_, old_val, new_val|
      old_val.merge(new_val)
    end
  end

  def sort_all_category_totals(data)
    Hash[data.to_a.sort { |a, b| b[1].abs <=> a[1].abs }]
  end
end
