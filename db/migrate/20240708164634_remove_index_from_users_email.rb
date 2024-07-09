class RemoveIndexFromUsersEmail < ActiveRecord::Migration[7.0]
  def change
    remove_index :users, column: :email, if_exists: true
  end
end
