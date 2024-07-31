class CreateResourcePackTypes < ActiveRecord::Migration[7.0]
  def change
    create_table :resource_pack_types do |t|
      t.string :name
      t.decimal :price
      t.integer :amount
      t.integer :valid_days

      t.timestamps
    end
  end
end
