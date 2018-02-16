class MonthlyReport < ApplicationRecord
  belongs_to :client

    
    validates_presence_of :client_id, message: "^Please select site!"
    validates_presence_of :date, message: "^Please select date!"
    validates_uniqueness_of :date, :scope => [:client_id], message: "^Report already exists on the selected date!", allow_blank: true

   has_attached_file :report_file, 
        :storage => :s3,
        :bucket => ENV['S3_BUCKET_NAME'],
        :s3_region => ENV['AWS_REGION']
        
    validates_presence_of :report_file, message: "^Please select a file!"
    validates_attachment :report_file, content_type: { content_type: "application/pdf" }, allow_blank: true


  def self.own_site(user_id)
        find_user_site = ClientUser.where(user_id: user_id)

        if find_user_site
            return client_sites = find_user_site.map{|x| x.client_id}
        end
  end

end
