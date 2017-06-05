# Stores several transactions to track expenses
class Ledger < ApplicationRecord
  has_many :transactions, dependent: :destroy

  has_many :ledger_uploads, inverse_of: :ledger, dependent: :destroy
  accepts_nested_attributes_for :ledger_uploads,
                                reject_if: proc { |attributes|
                                  attributes['data_source'].blank?
                                }

  validates_associated :ledger_uploads
  validates :name, presence: true

  def upload_data
    return unless ledger_uploads.last && !ledger_uploads.last.uploaded
    ledger_uploads.last.upload_data
  end

  def to_tab_delim
    keys = %w[date description amount balance account validated category
              subcategory comments]
    data = transactions.map do |trans|
      keys.map { |k| trans.attributes[k].to_s }.join("\t")
    end
    "#{keys.join("\t")}\n#{data.join("\n")}"
  end
end
