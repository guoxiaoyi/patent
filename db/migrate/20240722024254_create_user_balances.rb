class CreateUserBalances < ActiveRecord::Migration[7.0]
  def change
    create_table :user_balances do |t|
      t.references :billable, polymorphic: true, null: false, index: true
      t.integer :balance

      t.timestamps
    end
  end
end
