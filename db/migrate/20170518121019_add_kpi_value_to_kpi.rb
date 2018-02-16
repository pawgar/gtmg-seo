class AddKpiValueToKpi < ActiveRecord::Migration
  def change
    add_column :kpis, :kpi_value, :text, limit: 65535
  end
end
