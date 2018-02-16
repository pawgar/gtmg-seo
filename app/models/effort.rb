class Effort < ActiveRecord::Base
 
  belongs_to :strategy
  belongs_to :client
  belongs_to :user
  has_many   :qa_comments, dependent: :delete_all
  before_create :generate_token
  
  attr_writer :current_step
  attr_accessor :execute_standardValidation, :file, :file_data
  
  validate :standard_validation, if: :execute_standardValidation
  
  validate :check_file_type,    :if => lambda { |o| o.current_step == 'import_file' }
  validate :check_file_mapping, :if => lambda { |o| o.current_step == 'map_data' }
#  validates :feedback_token, presence: true, uniqueness: true, :if => lambda { |o| o.current_step == 'map_data' }
  
  def standard_validation
    
    if self.strategy_id.blank?
          errors.add(:strategy_id, "^Please enter Task Code!")
    elsif self.date.blank?
          errors.add(:date, "^Please select date!")
    elsif self.status_url.blank?
          errors.add(:status_url, "^Please add Status Url!")
    end
    
  end
  
  def self.search(search)
    #client = Client.where("name LIKE ?", "%#{search}%")
    client = Client.where(id: search)
    where(client_id: client.ids)
  end
  
  def self.get_range(client, start_date, end_date)

    client = Client.where(id: client)
    if start_date and end_date
      where(client_id: client.ids, date: start_date.to_date..end_date.to_date)
      
    elsif start_date and !end_date
      where(client_id: client.ids, date: start_date.to_date..DateTime.now.to_date)
      
    elsif !start_date and end_date
      where(client_id: client.ids, date: end_date.to_date - 5 .. end_date.to_date)
    end 
  end

  def self.get_range_all(start_date, end_date)

    if start_date and end_date
      where(date: start_date.to_date..end_date.to_date)
      
    elsif start_date and !end_date
      where(date: start_date.to_date..DateTime.now.to_date)
      
    elsif !start_date and end_date
      where(date: end_date.to_date - 5 .. end_date.to_date)
    end 
  end


  
  def current_step
    @current_step || steps.first
  end
  
  
  def steps
    %w[import_file map_data]
  end
  
  def next_step 
    self.current_step = steps[steps.index(current_step)+1]
  end

  def previous_step 
    self.current_step = steps[steps.index(current_step)-1]
  end  
  
  def first_step?
    current_step == steps.first
  end

  def last_step?
    current_step == steps.last
  end
  
  def all_valid?
    steps.all? do |step|
      self.current_step = step
      valid?
    end
  end

  
  def check_file_type
    if file.present?
      if file["file_type"] != '.xlsx' and file["file_type"] != '.xls'   
        #raise "Unknown file type:"
        errors.add(:file, "^Invalid file type ( #{file["file_type"]} )")
      end
    end
  end
  
  def check_file_mapping
    if file_data.present?
      if file_data["starting_row"].blank?
          errors.add(:file_data, "^Please enter starting row for import!")
          
      elsif file_data["last_row"].blank?
          errors.add(:file_data, "^Please enter last row for import!")

      elsif file_data["note_column"].blank?
          errors.add(:file_data, "^Please enter corresponding column for notes!")
          
      elsif file_data["date_column"].blank?
          errors.add(:file_data, "^Please enter corresponding column for date!")
          
      elsif file_data["task_code_column"].blank?
          errors.add(:file_data, "^Please enter corresponding column for task code!")
          
      elsif file_data["status_url_column"].blank?
          errors.add(:file_data, "^Please enter corresponding column for status url!")
          
      elsif file_data["feed_back_column"].blank?
          errors.add(:file_data, "^Please enter corresponding column for quality assurance!")
      end
    end
  end

private

  def generate_token
    self.feedback_token = SecureRandom.urlsafe_base64(15)
    generate_token if Effort.exists?(feedback_token: self.feedback_token)
  end
  
  
end
