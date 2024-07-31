class CreateRechargeTypes < ActiveRecord::Migration[7.0]
  def change
    create_table :recharge_types do |t|
      t.string :name
      t.decimal :price
      t.integer :amount

      t.timestamps
    end
  end
end
