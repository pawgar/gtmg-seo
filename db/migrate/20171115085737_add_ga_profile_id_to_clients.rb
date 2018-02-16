class AddGaProfileIdToClients < ActiveRecord::Migration[5.0]
  def change
    add_column :clients, :ga_profile_id, :integer
  end
end
