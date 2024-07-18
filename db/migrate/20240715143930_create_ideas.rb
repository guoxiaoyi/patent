class CreateIdeas < ActiveRecord::Migration[7.0]
  def change
    create_table :ideas do |t|
      t.text :question
      t.text :answer
      t.integer :user_id

      t.timestamps
    end
  end
end
