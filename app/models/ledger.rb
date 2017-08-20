# Stores several transactions to track expenses
class Ledger < ApplicationRecord
  include LedgerDownloadHelper
  has_many :transactions, inverse_of: :ledger, dependent: :destroy

  has_many :ledger_uploads, inverse_of: :ledger, dependent: :destroy
  accepts_nested_attributes_for :ledger_uploads,
                                reject_if: proc { |attributes|
                                  attributes['data_source'].blank?
                                }

  has_many :budget_ledgers, inverse_of: :ledger, dependent: :destroy

  has_many :budgets, through: :budget_ledgers

  validates :name, presence: true
  validates_associated :ledger_uploads

  def upload_data
    return unless ledger_uploads.last && !ledger_uploads.last.uploaded
    ledger_uploads.last.upload_data
  end

  def download_data
    to_tab_delim(transactions)
  end
end
