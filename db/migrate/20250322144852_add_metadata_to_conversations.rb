class AddMetadataToConversations < ActiveRecord::Migration[7.0]
  def change
    add_column :conversations, :metadata, :json
  end
end
