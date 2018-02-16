class AddNotesToEfforts < ActiveRecord::Migration
  def change
    add_column :efforts, :notes, :string, limit: 5000, default: nil
  end
end
