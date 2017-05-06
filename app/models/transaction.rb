# stores the information for a single monetary transaction
class Transaction < ApplicationRecord
  include ActionView::Helpers::NumberHelper

  belongs_to :ledger
  belongs_to :ledger_upload

  attr_accessor :display_data

  # processes a tab delimited record string into a hash
  def self.process_transaction_data(column_names, data)
    data = data.split(/\t/)
    data = Hash[column_names.zip data]
    #
    # process data values
    data['date'] = Date.strptime(data['date'].strip, '%m/%d/%y').to_s
    data['amount'] = format('%.2f', Float(data['amount'].delete(',')))
    data['balance'].gsub!(/[[:space:]]/, '')
    unless data['balance'].empty?
      data['balance'] = format('%.2f', Float(data['balance'].delete(',')))
    end
    data['validated'] = data['validated'] == 'OK' ? true : false
    #
    data
  end

  # returns an array of column names to display in order
  def self.display_columns
    %w[date description amount balance account validated
       category subcategory comments]
  end

  def self.display_number(number)
    helper = Object.new.extend(ActionView::Helpers::NumberHelper)
    helper.number_with_precision(number, delimiter: ',', precision: 2)
  end

  # returns a formatted hash for display
  def gen_display_hash
    @display_data = attributes.to_h
    @display_data['amount'] = Transaction.display_number(amount)
    @display_data['balance'] = Transaction.display_number(balance)
    @display_data['validated'] = validated ? 'YES' : 'NO'
  end
end
