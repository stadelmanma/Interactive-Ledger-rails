# stores the information for a single monetary transaction
class Transaction < ApplicationRecord
  include ActionView::Helpers::NumberHelper

  belongs_to :ledger, inverse_of: :transactions
  belongs_to :ledger_upload, inverse_of: :transactions

  scope(:categories, lambda {
    distinct.where("category REGEXP '.+'").pluck(:category)
  })
  scope(:subcategories, lambda {
    distinct.where("subcategory REGEXP '.+'").pluck(:subcategory)
  })

  auto_strip_attributes :category, :subcategory, :comments, :account,
                        nullify: false, squish: true

  attr_accessor :display_data

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

  # checks for transactions sharing the same amount and a date
  def possible_dupes
    where = [
      'id != ?',
      'ledger_id = ?',
      'ledger_upload_id != ?',
      'date = ?',
      'ROUND(amount, 2) = ?'
    ].join(' AND ')
    Transaction.where(where, id, ledger_id, ledger_upload_id, date, amount)
  end
end
