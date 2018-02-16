class CreateClientUsers < ActiveRecord::Migration
  def change
    create_table :client_users do |t|
      t.references :user, index: true, foreign_key: true
      t.references :client, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
