class Krm < ActiveRecord::Base
  belongs_to :client

  validates_presence_of :client, message: "^Please select client!"
  validates_presence_of :keywords, message: "^Keyword can't be blank!" 
  validates_length_of :keywords, :maximum => 255, :allow_blank => true, message: "^Keyword is too long (maximum is 1000 characters)"
  validates_uniqueness_of :keywords, case_sensitive: false, scope: [:client_id, :date], message: "^Keyword exist on this client for the selected date!", allow_blank: true 
  validates_presence_of :date
  validates_presence_of :page_rank

  before_save :downcase_keyword
  
  private

  def downcase_keyword
    self.keywords.downcase!  
    #downcase returns a copy of the string, doesn't modify the string itself. Use downcase! instead
  end

  def self.search(search)
      where(client_id: search)
  end
    
  def self.get_range(client, start_date, end_date)
    if start_date and end_date
      where(client_id: client, date: start_date.to_date..end_date.to_date)
      
    elsif start_date and !end_date
      where(client_id: client, date: start_date.to_date..DateTime.now.to_date)
      
    elsif !start_date and end_date
      where(client_id: client, date: end_date.to_date - 6.months .. end_date.to_date)
    end
  end

  
end
