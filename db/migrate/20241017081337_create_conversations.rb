class CreateConversations < ActiveRecord::Migration[7.0]
  def change
    create_table :conversations do |t|
      t.string :request_id, limit: 36, null: false  # UUID 格式通常为 36 个字符
      t.string :title
      t.references :user, null: false, foreign_key: true
      t.references :feature, null: false, foreign_key: true
      t.references :tenant, null: false, foreign_key: true
      t.references :project, null: false, foreign_key: true
      t.boolean :processing, default: false
      t.datetime :deleted_at
      t.timestamps
    end

    add_index :conversations, :request_id, unique: true
    add_index :conversations, :deleted_at
  end
end
