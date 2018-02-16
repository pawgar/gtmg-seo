class AddResetTokenToUser < ActiveRecord::Migration
  def change
    add_column :users, :reset_token, :string, limit: 100, null: true
  end
end
