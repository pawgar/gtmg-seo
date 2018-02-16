class CreateMonthlyReports < ActiveRecord::Migration[5.0]
  def change
    create_table :monthly_reports do |t|
      t.references :client, foreign_key: true
      t.datetime :date

      t.timestamps
    end
  end
end
