class CreateKpiObjectives < ActiveRecord::Migration
  def change
    create_table :kpi_objectives do |t|
      t.string :title, limit: 2000

      t.timestamps null: false
    end
  end
end
