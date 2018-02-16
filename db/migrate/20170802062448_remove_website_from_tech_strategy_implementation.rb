class RemoveWebsiteFromTechStrategyImplementation < ActiveRecord::Migration
  def change
    remove_column :tech_strategy_implementations, :website, :integer
  end
end
