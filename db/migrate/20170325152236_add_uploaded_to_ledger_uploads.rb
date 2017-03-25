class AddUploadedToLedgerUploads < ActiveRecord::Migration[5.0]
  def change
    add_column :ledger_uploads, :uploaded, :boolean
  end
end
