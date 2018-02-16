class StrategyOffpageCategory < ApplicationRecord
  belongs_to :offpage_category
  belongs_to :strategy


  validates_presence_of :strategy_id
  validates_presence_of :offpage_category_id

  validates_uniqueness_of :offpage_category_id, :scope => :strategy_id, :message => "^Category already exists!"

end
