class CreateConversations < ActiveRecord::Migration[7.0]
  def change
    create_table :conversations, id: false do |t|
      t.string :id, primary_key: true, limit: 36
      t.string :title
      t.references :user, null: false, foreign_key: true
      t.references :feature, null: false, foreign_key: true
      t.references :tenant, null: false, foreign_key: true
      t.boolean :processing, default: false
      t.timestamps
    end
  end
end