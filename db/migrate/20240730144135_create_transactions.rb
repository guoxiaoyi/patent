class CreateTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :transactions do |t|
      t.string :account_type
      t.integer :account_id
      t.integer :amount
      t.integer :transaction_type
      t.string :transactionable_type
      t.integer :transactionable_id
      t.string :description

      t.timestamps
    end
  end
end
