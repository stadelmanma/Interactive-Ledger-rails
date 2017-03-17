class RemoveDataSourceFromLegers < ActiveRecord::Migration[5.0]
  def change
    remove_column :ledgers, :data_source
    remove_column :ledgers, :string
  end
end
