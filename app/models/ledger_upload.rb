# Manages an upload from a data source and sends it to the database
class LedgerUpload < ApplicationRecord
  belongs_to :ledger, inverse_of: :ledger_uploads
  has_many :transactions, dependent: :destroy
  accepts_nested_attributes_for :transactions

  validates :ledger, presence: true
  validates :data_source, presence: true, on: :create
  validate :data_path_exists, on: :create

  def upload_data
    # check if data has already been uploaded
    return if uploaded
    # process and upload new data
    transactions = load_data
    Transaction.import transactions
    update!(uploaded: true)
    ledger.touch if ledger.persisted?
  end

  private

  def data_path_exists
    return unless File.file? data_source
    #
    path = File.absolute_path(data_source)
    errors[:base] << "Error: The requested file does not exist: '#{path}'"
  end

  def load_data
    # loading raw data and splitting by new lines
    path = Rails.root.to_s + '/' + data_source
    data = File.read(path).split(/\n/)

    # processing header row
    column_names = headers_to_column_names(data.shift)

    # processing transaction data
    data.map! do |row|
      trans_data = Transaction.process_transaction_data(column_names, row)
      trans_data[:ledger_id] = ledger.id
      trans_data[:ledger_upload_id] = id
      Transaction.new(trans_data)
    end
    #
    data
  end

  # processes header row to create valid attribute keys
  def headers_to_column_names(header)
    header = header.split(/\t/)
    column_names = header.map { |name| name.downcase.strip }
    column_names.map! { |name| name.sub(/\s+/, '_') }
  end
end
