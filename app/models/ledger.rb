class Ledger < ApplicationRecord
  has_many :transactions, dependent: :destroy
  validates :name, presence: true
  validates :data_source, presence: true
  
  # processes header row to create valid attribute keys
  def headers_to_column_names(header)
    header = header.split(/\t/)
    column_names = header.map {|name| name.downcase.strip}
    column_names.map! {|name| name.sub /\s+/, '_'}
  end
  
  # loading data from file specified by data_source attribute
  def load_data
    # loading initial data
    path = Rails.root.to_s + '/' + data_source
    data = File.read(path).split(/\n/)
    
    # processing header row
     column_names = headers_to_column_names(data.shift)
    
    # processing transaction data
    data.map! do |row| 
      trans_data = Transaction.process_transaction_data(column_names, row)
      #self.transactions.create(trans_data)
    end
    #
    return column_names, data
  end
  
end
