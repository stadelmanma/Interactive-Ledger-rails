class Transaction < ApplicationRecord
  belongs_to :ledger
  
  # processes a tb delimited string
  def self.process_transaction_data(column_names, data)
    data = data.split(/\t/)
    data = Hash[column_names.zip data]
    return data
  end
end
