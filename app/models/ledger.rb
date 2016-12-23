class Ledger < ApplicationRecord
  has_many :transactions, dependent: :destroy
  validates :name, presence: true
  validates :data_source, presence: true
  
  def load_data
    # loading initial data
    path = Rails.root.to_s + '/' + data_source
    data = File.read(path).split(/\n/)
    
    # processing header row to obtain column names
    header = data.shift.split(/\t/)
    column_names = header.map {|name| name.downcase.strip}
    column_names.map! {|name| name.sub /\s+/, '_'}
    
    # processing transaction data
    data.map! do |row| 
      trans_data = Transaction.process_transaction_data(column_names, row)
      trans = Transaction.new(trans_data)
    end
    #
    return header, data
  end
  
end
