class ChangeColumnTypeInConversations < ActiveRecord::Migration[7.0]
  def change
    change_column :conversations, :title, :string, default: 'text'
  end
end
