class Transaction < ApplicationRecord
  belongs_to :ledger
  
  # processes a tb delimited string
  def self.process_transaction_data(column_names, data)
    data = data.split(/\t/)
    data = Hash[column_names.zip data]
    data['date'] = Date.strptime(data['date'].strip, '%m/%d/%y').to_s
    data['validated'] = data['validated'] == 'OK' ? 'YES' : 'NO'
    #
    return data
  end
end
