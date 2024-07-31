class CreateResourcePacks < ActiveRecord::Migration[7.0]
  def change
    create_table :resource_packs do |t|
      t.references :owner, polymorphic: true, null: false
      t.references :resource_pack_type, null: false, foreign_key: true
      t.integer :amount
      t.integer :status, default: 0, null: false
      t.datetime :valid_from, null: false
      t.datetime :valid_to, null: false

      t.timestamps
    end
  end
end
