# Stores several transactions to track expenses
class Ledger < ApplicationRecord
  include LedgerDownloadHelper
  has_many :transactions, inverse_of: :ledger, dependent: :destroy

  has_many :ledger_uploads, inverse_of: :ledger, dependent: :destroy
  accepts_nested_attributes_for :ledger_uploads,
                                reject_if: proc { |attributes|
                                  attributes['data_source'].blank?
                                }

  has_many :category_exclusions, inverse_of: :ledger, dependent: :destroy
  accepts_nested_attributes_for :category_exclusions,
                                allow_destroy: true,
                                reject_if: proc { |attributes|
                                  chk = %i[category excluded_from]
                                  attributes.values_at(*chk).any?(&:blank?)
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

  # Returns all transactions except those with a category excluded
  # by the category exclusions group passed in.
  #
  # @param [Array<String>] exclusions 'excluded_from' values to match
  #
  # @return [ActiveRecord_Relation<Transaction>]
  #
  def transactions_not_excluded_from(*exclusions)
    # we always want to exclude 'all' because it should be excluded from
    # everywhere.
    exclusions << 'all' unless exclusions.include? 'all'
    #
    excluded_cats = category_exclusions.where(excluded_from: exclusions)
    transactions.where.not(category: excluded_cats.pluck(:category))
  end
end
