class CreateLedgers < ActiveRecord::Migration[5.0]
  def change
    create_table :ledgers do |t|
      t.string :name
      t.string :data_source
      t.string :string

      t.timestamps
    end
  end
end
