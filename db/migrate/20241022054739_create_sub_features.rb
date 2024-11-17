class CreateSubFeatures < ActiveRecord::Migration[7.0]
  def change
    create_table :sub_features do |t|
      t.string :name
      t.text :prompt
      t.integer :feature_key
      t.integer :sort_order  # 子功能的排序
      t.references :feature, foreign_key: true  # 关联父功能

      t.timestamps
    end
  end
end
