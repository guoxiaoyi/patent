class ChangeProjectIdNullableInConversations < ActiveRecord::Migration[7.0]
  def change
    change_column_null :conversations, :project_id, true
  end
end
