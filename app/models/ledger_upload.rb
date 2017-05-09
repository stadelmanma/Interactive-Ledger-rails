# Manages an upload from a data source and sends it to the database
class LedgerUpload < ApplicationRecord
  include LedgerUploadHelper

  belongs_to :ledger, inverse_of: :ledger_uploads
  has_many :transactions, dependent: :destroy
  accepts_nested_attributes_for :transactions

  validates :ledger, presence: true
  validates :data_source, presence: true, on: :create
  validate :data_path_exists, on: :create

  attr_accessor :upload_format
  attr_accessor :account

  def upload_data
    # check if data has already been uploaded
    return if uploaded
    # process and upload new data
    transactions = load_data
    Transaction.import transactions
    update!(uploaded: true)
    ledger.touch if ledger.persisted?
    self
  end

  private

  def data_path_exists
    path = File.absolute_path(data_source)
    return if File.file? path
    #
    errors[:base] << "Error: The requested file does not exist: '#{path}'"
  end

  def load_data
    # loading raw data and splitting by new lines
    path = Rails.root.to_s + '/' + data_source

    # processing transaction data
    upload_from_format(path, @upload_format) do |trans_data|
      trans_data[:account] = @account
      trans_data[:ledger_id] = ledger.id
      trans_data[:ledger_upload_id] = id
      Transaction.new(trans_data.to_h)
    end
  end
end
