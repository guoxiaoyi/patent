class CreateTenants < ActiveRecord::Migration[7.0]
  def change
    create_table :tenants do |t|
      t.string :name
      t.string :subdomain
      t.string :domain
      t.integer :billingMode, default: 0

      t.timestamps
    end
    add_index :tenants, :subdomain, unique: true
    add_index :tenants, :domain, unique: true
  end
end
