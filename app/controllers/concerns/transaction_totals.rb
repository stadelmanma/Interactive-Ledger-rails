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
    transactions = ledger.transactions
    {
      0 => {
        rowspan: transactions.length,
        week_total: 1,
        total_deficit: 2,
        category_totals: {'Test' => 0}
      }
    }
  end

end
