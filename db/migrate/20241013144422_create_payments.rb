class CreatePayments < ActiveRecord::Migration[7.0]
  def change
    create_table :payments do |t|
      t.references :user, null: false, foreign_key: true
      t.references :tenant, null: false, foreign_key: true
      t.decimal :amount, precision: 10, scale: 2 
      t.string :code
      t.string :status
      t.integer :transaction_id
      t.references :paymentable, polymorphic: true, null: false

      t.timestamps
    end
  end
end
