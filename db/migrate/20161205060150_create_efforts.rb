class CreateEfforts < ActiveRecord::Migration
  def change
    create_table :efforts do |t|
      t.references :strategy, index: true, foreign_key: true
      t.references :client, index: true, foreign_key: true
      t.timestamp :date
      t.text :status_url, limit: 65535, null: true
      t.references :user, index: true, foreign_key: true
      t.string :qa, limit: 9999

      t.timestamps null: false
    end
  end
end
