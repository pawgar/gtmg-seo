class User < ActiveRecord::Base
    
    has_many :social_auths, :dependent => :delete_all
    
    has_many :client_users
    has_many :efforts
    has_many :clients, :through => :client_users
    has_many :qa_comments
    #has_one :client, :dependent => :delete
    
    #before_create :build_client_profile
    
    enum status: [:inactive, :active]
    enum role: { Administrator: 1, Client: 2 }
    
    
    validates :firstname, presence: true
    validates :lastname, presence: true
    validates :password, length: {:within => 6..100},  allow_blank: true, unless: :skip_password_validation
    
    
    EMAIL_REGEX = /\A[^@\s]+@([^@.\s]+\.)+[^@.\s]+\z/
    
    validates :email, presence: true, uniqueness: true, length: { maximum: 100 }, confirmation: true
	validates :email, format: EMAIL_REGEX, allow_blank: true
    
    has_secure_password
    
    
    has_attached_file :avatar, styles: 
        { 
        medium: "700x700",
        small: "350x350>",
        thumb: "150x150>", 
        s100: "100x100>"   
        },
        :storage => :s3,
        :bucket => ENV['S3_BUCKET_NAME'],
        :s3_region => ENV['AWS_REGION']
        
    
    validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\z/
    
    
    attr_accessor :skip_password_validation
    
    
    def create_reset_digest
        self.reset_token = generate_token
        self.token_sent_at = Time.zone.now
        save(validate: false)
    end
    
    def password_reset_expired?
	    token_sent_at < 2.hours.ago
	 end
	 
	 def self.admin_counter
	     self.Administrator.count
	 end
    
     def apply_omniauth(auth)
        
        	  # In previous omniauth, 'user_info' was used in place of 'raw_info'

        	  if auth['provider'] == 'facebook'
        	  		self.firstname = auth['extra']['raw_info']['first_name']
        	        self.lastname = auth['extra']['raw_info']['last_name']
        	  else
        	        self.firstname = auth['info']['first_name']   #google #linkedin
        	        self.lastname = auth['info']['last_name']
        	  end
        	  
        	  self.email = auth['info']['email']
        	  self.password = BCrypt::Password.create(generate_token)
        	  social_auths.build(:provider => auth['provider'], :uid => auth['uid'], :token => auth['credentials']['token'])
	 end
	
	def name_and_email
	   "#{firstname} #{lastname}".titleize + " (#{email})"
	end
	
	def fullname
	   "#{firstname} #{lastname}".titleize 
	end
    
    private
    
    def generate_token
        SecureRandom.urlsafe_base64 
    end
    
    def build_client_profile
        build_client
    end
end
