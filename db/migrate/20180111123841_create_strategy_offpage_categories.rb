class CreateStrategyOffpageCategories < ActiveRecord::Migration[5.0]
  def change
    create_table :strategy_offpage_categories do |t|
      t.references :offpage_category, foreign_key: true
      t.references :strategy, foreign_key: true

      t.timestamps
    end
  end
end
