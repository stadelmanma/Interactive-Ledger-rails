class Ledger < ApplicationRecord
  has_many :transactions, dependent: :destroy
  validates :name, presence: true
  validates :data_source, presence: true
end
