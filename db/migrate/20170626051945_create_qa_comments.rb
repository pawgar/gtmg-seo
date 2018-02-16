class CreateQaComments < ActiveRecord::Migration
  def change
    create_table :qa_comments do |t|
      t.references :effort, index: true, foreign_key: true
      t.text :comment
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
