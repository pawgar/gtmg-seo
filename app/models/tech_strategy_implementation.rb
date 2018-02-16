class TechStrategyImplementation < ActiveRecord::Base
  belongs_to :technical_strategy
  belongs_to :client
  
  enum status: { done: 1, 'n/a': 2, pending: 3}
  
  def self.search(search)
     client = Client.where(id: search)
     where(client_id: client.ids)
  end
    
  def self.get_range(client, start_date, end_date)
    client = Client.where(id: client)
    if start_date and end_date
      
      where(client_id: client.ids, created_at: start_date.to_date.beginning_of_day .. end_date.to_date.end_of_day)
      
    elsif start_date and !end_date
      where(client_id: client.ids, created_at: start_date.to_date.beginning_of_day .. DateTime.now.to_date.end_of_day)
      
    elsif !start_date and end_date
      where(client_id: client.ids, created_at: end_date.to_date.prev_month.beginning_of_day .. end_date.to_date.end_of_day)
    end
  end
  
end
