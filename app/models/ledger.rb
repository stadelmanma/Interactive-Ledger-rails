class Ledger < ApplicationRecord
  validates :name, presence: true
  validates :data_source, presence: true
end
