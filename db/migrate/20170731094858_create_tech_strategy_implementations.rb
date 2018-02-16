class CreateTechStrategyImplementations < ActiveRecord::Migration
  def change
    create_table :tech_strategy_implementations do |t|
      t.references :technical_strategy, index: true, foreign_key: true
      t.integer :status
      t.text :comments
      t.integer :website

      t.timestamps null: false
    end
  end
end
