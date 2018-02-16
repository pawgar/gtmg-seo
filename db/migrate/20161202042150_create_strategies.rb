class CreateStrategies < ActiveRecord::Migration
  def change
    create_table :strategies do |t|
      t.string :code, limit: 200
      t.string :description, limit: 9999
      t.string :notes, limit: 9999, null: true

      t.timestamps null: false
    end
  end
end
