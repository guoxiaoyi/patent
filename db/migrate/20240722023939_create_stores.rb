class CreateStores < ActiveRecord::Migration[7.0]
  def change
    create_table :stores do |t|
      t.string :name
      t.string :domain
      t.integer :billingMode, default: 0

      t.timestamps
    end
  end
end
