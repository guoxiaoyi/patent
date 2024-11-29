class CreateArticles < ActiveRecord::Migration[7.0]
  def change
    create_table :articles do |t|
      t.string :title
      t.text :content
      t.string :author
      t.integer :status
      t.references :category, null: false, foreign_key: true

      t.timestamps
    end
  end
end
