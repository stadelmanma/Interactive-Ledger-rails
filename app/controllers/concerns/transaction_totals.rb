module TransactionTotals
  extend ActiveSupport::Concern

  included do
    helper_method :create_totals_hash
  end

  def create_totals_hash(ledger)
    transactions = ledger.transactions
    {
      0 => {
        rowspan: transactions.length,
        totals: {
          week_total: 0,
          total_deficit: 0,
          category_totals: 0
        }
      }
    }
  end

end
