class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      
      t.string :firstname, limit: 50
      t.string :lastname, limit: 50
      t.string :email, limit: 50
      t.string :password_digest
      t.integer :status, default: 1

      t.timestamps null: false
    end
  end
end
