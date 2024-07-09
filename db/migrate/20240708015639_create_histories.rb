class CreateHistories < ActiveRecord::Migration[7.0]
  def change
    create_table :histories do |t|
      t.text :question
      t.text :answer
      t.integer :category
      t.integer :user_id

      t.timestamps
    end
  end
end
