class AddCodeToClient < ActiveRecord::Migration
  def change
    add_column :clients, :code, :string, limit: 5, default: nil
  end
end
