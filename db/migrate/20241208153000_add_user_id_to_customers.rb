class AddUserIdToCustomers < ActiveRecord::Migration[7.0]
  def change
    add_column :customers, :user_id, :bigint
  end
end
