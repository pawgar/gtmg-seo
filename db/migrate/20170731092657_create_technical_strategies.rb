class CreateTechnicalStrategies < ActiveRecord::Migration
  def change
    create_table :technical_strategies do |t|
      t.text :notes
      t.text :description

      t.timestamps null: false
    end
  end
end
