class LedgerUpload < ApplicationRecord
  belongs_to :ledger
  has_many :transactions, dependent: :destroy

  validates :data_source, presence: true

  def self.create_from_ledger(ledger, params)
    LedgerUpload.create!(params)
  end
end
