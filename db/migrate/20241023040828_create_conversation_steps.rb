class CreateConversationSteps < ActiveRecord::Migration[7.0]
  def change
    create_table :conversation_steps do |t|
      t.references :conversation, null: false, foreign_key: true
      t.references :sub_feature, null: false, foreign_key: true
      t.integer :status
      t.text :error_message
      t.datetime :deleted_at
      
      t.timestamps

    end
    add_index :conversation_steps, :deleted_at
  end
end
