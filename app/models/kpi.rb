class Kpi < ActiveRecord::Base
  belongs_to :client
  belongs_to :kpi_objective

  validates_presence_of :client, message: "^Please select client!"
#  validates_presence_of :title, message: "^Keyword can't be blank!"
#  validates_length_of :title, :maximum => 255, :allow_blank => true, message: "^Keyword is too long (maximum is 255 characters)"
#  validates_presence_of :date
#  validates_uniqueness_of :title, scope: [:client_id, :date], message: "^Data exist on this client for the selected date!", allow_blank: true 
    validates_presence_of :kpi_objective_id, message: "^Invalid keyword!"
    validates_uniqueness_of :date, :scope => [:client_id, :kpi_objective_id], message: "^Data already exists on the selected keyword and date!"
    
    def self.search(search)
        where(client_id: search)
    end
    
    def self.get_range(client, start_date, end_date)
      
      client = Client.where(id: client)
      if start_date and end_date
        where(client_id: client.ids, date: start_date.to_date..end_date.to_date)
        
      elsif start_date and !end_date
        where(client_id: client.ids, date: start_date.to_date..DateTime.now.to_date)
        
      elsif !start_date and end_date
        where(client_id: client.ids, date: end_date.to_date - 6.months .. end_date.to_date)
      end
    end
  
end
