class CreateResourcePackTypes < ActiveRecord::Migration[7.0]
  def change
    create_table :resource_pack_types do |t|
      t.string :name
      t.decimal :price, precision: 10, scale: 2
      t.decimal :discount, precision: 10, scale: 2
      t.integer :amount
      t.integer :bonus, default: 0
      t.integer :valid_days
      t.datetime :deleted_at

      t.timestamps
    end
    add_index :resource_pack_types, :deleted_at
  end
end
