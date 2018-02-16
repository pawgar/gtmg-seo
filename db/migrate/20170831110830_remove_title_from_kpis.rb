class RemoveTitleFromKpis < ActiveRecord::Migration
  def change
    remove_column :kpis, :title, :string
  end
end
