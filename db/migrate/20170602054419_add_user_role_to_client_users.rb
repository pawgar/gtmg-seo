class AddUserRoleToClientUsers < ActiveRecord::Migration
  def change
    add_column :client_users, :user_role, :integer, default: 0
  end
end
