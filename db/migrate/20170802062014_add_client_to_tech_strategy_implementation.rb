class AddClientToTechStrategyImplementation < ActiveRecord::Migration
  def change
    add_reference :tech_strategy_implementations, :client, index: true, foreign_key: true
  end
end
