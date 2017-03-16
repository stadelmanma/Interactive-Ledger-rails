class Ledger < ApplicationRecord
  has_many :transactions, dependent: :destroy

  has_many :ledger_uploads, dependent: :destroy
  accepts_nested_attributes_for :ledger_uploads

  validates :name, presence: true
end
