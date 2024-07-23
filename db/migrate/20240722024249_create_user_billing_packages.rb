class CreateUserBillingPackages < ActiveRecord::Migration[7.0]
  def change
    create_table :user_billing_packages do |t|
      t.references :billable, polymorphic: true, null: false, index: true
      t.integer :stars
      t.datetime :expiration_date

      t.timestamps
    end
  end
end
