class OffpageCategory < ApplicationRecord
	has_many :strategy_offpage_categories, :dependent => :delete_all
	has_many :strategies, through: :strategy_offpage_categories


	validates :code_letter, presence: true, uniqueness: true, :case_sensitive => false, length: { maximum: 10 }
    validates :category_name, presence: true, uniqueness: true, :case_sensitive => false, length: { maximum: 5999 }
end
