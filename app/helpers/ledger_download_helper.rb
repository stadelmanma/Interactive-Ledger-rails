require 'csv'

# Handles downloading transaction data
module LedgerDownloadHelper
  #
  # exports the transactions array to a tab delim format
  def to_tab_delim(transactions)
    keys = %w[date description amount balance account validated category
              subcategory comments]
    #
    options = { quote_char: '"', col_sep: "\t", headers: keys,
                write_headers: true }
    # return the CSV string
    CSV.generate(options) do |csv|
      transactions.each do |trans|
        csv << keys.map { |k| trans.attributes[k].to_s }
      end
    end
  end
end
