class CreateProjects < ActiveRecord::Migration[7.0]
  def change
    create_table :projects do |t|
      t.string :name
      t.references :customer, null: true, foreign_key: true
      t.references :tenant, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.datetime :deleted_at
      t.timestamps
    end
    add_index :projects, :deleted_at
  end
end
