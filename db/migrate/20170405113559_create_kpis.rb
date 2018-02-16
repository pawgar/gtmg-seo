class CreateKpis < ActiveRecord::Migration
  def change
    create_table :kpis do |t|
      t.references :client, index: true, foreign_key: true
      t.string :title
      t.datetime :date

      t.timestamps null: false
    end
  end
end
