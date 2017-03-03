class Transaction < ApplicationRecord
  belongs_to :ledger

  # processes a tb delimited string
  def self.process_transaction_data(column_names, data)
    data = data.split(/\t/)
    data = Hash[column_names.zip data]
    #
    # process data values
    data['date'] = Date.strptime(data['date'].strip, '%m/%d/%y').to_s
    data['amount'] = '%.2f' % Float(data['amount'].gsub(',', ''))
    data['balance'].gsub!(/[[:space:]]/,'')
    if !data['balance'].empty?
        data['balance'] = '%.2f' % Float(data['balance'].gsub(',', ''))
    end
    data['validated'] = data['validated'] == 'OK' ? 'YES' : 'NO'
    #
    return data
  end
end
