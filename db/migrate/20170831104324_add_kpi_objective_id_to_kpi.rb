class AddKpiObjectiveIdToKpi < ActiveRecord::Migration
  def change
    add_reference :kpis, :kpi_objective, index: true, foreign_key: true
  end
end
