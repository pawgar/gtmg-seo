class Strategy < ActiveRecord::Base
    
    has_many :efforts, :dependent => :delete_all
    has_many :strategy_offpage_categories, :dependent => :delete_all
    has_many :offpage_categories, through: :strategy_offpage_categories
    
    validates :code, presence: true, uniqueness: true, length: { maximum: 20 }
    validates :description, presence: true, length: { maximum: 2000 }
    validates :notes, length: { maximum: 9000 }
    
end
