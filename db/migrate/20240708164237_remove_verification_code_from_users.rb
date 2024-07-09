class RemoveVerificationCodeFromUsers < ActiveRecord::Migration[7.0]
  def change
    remove_column :users, :verification_code, :string
  end
end
