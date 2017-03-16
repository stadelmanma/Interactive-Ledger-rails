class LedgerUpload < ApplicationRecord
  belongs_to :ledger, inverse_of: :ledger_uploads
  has_many :transactions, dependent: :destroy

  validates :ledger, presence: true
  validates :data_source, presence: true

  def upload_data
    # process and upload new data
    transactions = load_data
    Transaction.import transactions
    if ledger.persisted?
      ledger.touch
    end
  end

  private

  def load_data
    # loading raw data and splitting by new lines
    path = Rails.root.to_s + '/' + data_source
    data = File.read(path).split(/\n/)

    # processing header row
     column_names = headers_to_column_names(data.shift)

    # processing transaction data
    data.map! do |row|
      trans_data = Transaction.process_transaction_data(column_names, row)
      trans_data[:ledger_id] = self.ledger.id
      trans_data[:ledger_upload_id] = self.id
      Transaction.new(trans_data)
    end
    #
    return data
  end

  # processes header row to create valid attribute keys
  def headers_to_column_names(header)
    header = header.split(/\t/)
    column_names = header.map {|name| name.downcase.strip}
    column_names.map! {|name| name.sub /\s+/, '_'}
  end
end
