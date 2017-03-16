class CreateLedgerUploads < ActiveRecord::Migration[5.0]
  def change
    create_table :ledger_uploads do |t|
      t.references :ledger, foreign_key: true
      t.string :data_source

      t.timestamps
    end

    add_column :transactions, :ledger_upload_id, :integer
    add_index :transactions, :ledger_upload_id
  end
end
