class AddNotNullToUsersPasswordDigest < ActiveRecord::Migration[6.0]
  def change
    change_column :users, :password_digest, :string, null: false
  end
end
