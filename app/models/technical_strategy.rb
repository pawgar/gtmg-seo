class TechnicalStrategy < ActiveRecord::Base

	has_many :tech_strategy_implementation, :dependent => :delete_all

    validates :description, presence: true, uniqueness: true, length: { maximum: 2000 }
        
end
