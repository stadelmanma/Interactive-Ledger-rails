class Ledger < ApplicationRecord
  has_many :transactions, dependent: :destroy

  has_many :ledger_uploads, inverse_of: :ledger, dependent: :destroy
  accepts_nested_attributes_for :ledger_uploads,
    :reject_if => proc { |attributes| attributes['data_source'].blank? }

  validates_associated :ledger_uploads
  validates :name, presence: true
end
