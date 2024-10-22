class CreateFeatures < ActiveRecord::Migration[7.0]
  def change
    create_table :features do |t|
      t.string :name
      t.string :feature_key
      t.text :prompt
      t.integer :cost

      t.timestamps
    end
  end
end
