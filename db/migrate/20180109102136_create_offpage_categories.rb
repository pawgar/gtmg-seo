class CreateOffpageCategories < ActiveRecord::Migration[5.0]
  def change
    create_table :offpage_categories do |t|
      t.string :code_letter
      t.string :category_name, limit: 5999

      t.timestamps
    end
  end
end
