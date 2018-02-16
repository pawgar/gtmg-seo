class CreateKrms < ActiveRecord::Migration
  def change
    create_table :krms do |t|
      t.references :client, index: true, foreign_key: true
      t.string :keywords, limit: 1000
      t.datetime :date
      t.string :page_rank, limit: 9999

      t.timestamps null: false
    end
  end
end
