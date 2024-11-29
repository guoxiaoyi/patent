class CreateCategories < ActiveRecord::Migration[7.0]
  def change
    create_table :categories do |t|
      t.string :name
      t.string :slug
      t.integer :parent_id

      t.timestamps
    end

    add_index :categories, :slug, unique: true
    add_index :categories, :parent_id
  end
end
