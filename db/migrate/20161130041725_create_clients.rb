class CreateClients < ActiveRecord::Migration
  def change
    create_table :clients do |t|
      t.string :name
      t.string :notes, limit: 9999

      t.timestamps null: false
    end
  end
end
