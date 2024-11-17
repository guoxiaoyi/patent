class CreateRechargeTypes < ActiveRecord::Migration[7.0]
  def change
    create_table :recharge_types do |t|
      t.string :name
      t.decimal :price, precision: 10, scale: 2
      t.decimal :discount, precision: 10, scale: 2
      t.integer :amount
      t.json :rules
      
      t.datetime :deleted_at
      t.timestamps
    end

    add_index :recharge_types, :deleted_at
  end
end
