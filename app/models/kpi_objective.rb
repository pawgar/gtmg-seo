class KpiObjective < ActiveRecord::Base
    has_many :kpis, :dependent => :delete_all

    validates_presence_of :title
    validates_uniqueness_of :title, case_sensitive: false, message: "^Record already exist!"
    validates_length_of :title, maximum: 2000, allow_black: true

    before_validation :strip_title_field

private

    def strip_title_field
	  self.title.strip!
    end


end
