# Manages an upload from a data source and sends it to the database
class LedgerUpload < ApplicationRecord
  include LedgerUploadHelper

  belongs_to :ledger, inverse_of: :ledger_uploads, touch: true
  has_many :transactions, dependent: :destroy
  accepts_nested_attributes_for :transactions, allow_destroy: true

  # need to catch the uploaded file ActionDispatch before type casting
  before_create do
    @uploaded_file = @attributes['data_source'].value_before_type_cast
    self.data_source = @uploaded_file.original_filename
  end

  validates :ledger, presence: true
  validates :data_source, presence: true, on: :create

  attr_accessor :uploaded_file
  attr_accessor :upload_format
  attr_accessor :account

  def upload_data
    # check if data has already been uploaded
    return if uploaded
    # process and upload new data
    transactions = load_data
    Transaction.import transactions
    update!(uploaded: true)
    # change data_source attribute to just be the filename
    @data_source = @uploaded_file.original_filename
    # return the upload object
    self
  end

  private

  def load_data
    # processing transaction data
    upload_from_format(@uploaded_file, @upload_format) do |trans_data|
      trans_data[:account] = @account
      trans_data[:ledger_id] = ledger.id
      trans_data[:ledger_upload_id] = id
      Transaction.new(trans_data.to_h)
    end
  end
end
