class Client < ActiveRecord::Base
  has_many :client_users, :dependent => :delete_all
  has_many :users, :through => :client_users
  has_many :efforts, :dependent => :delete_all
  has_many :krms, :dependent => :delete_all
  has_many :kpis, :dependent => :delete_all
  has_many :tech_strategy_implementations, :dependent => :delete_all
  has_many :monthly_reports, :dependent => :delete_all
  #validates :notes, length: { maximum: 10 }
  
  validates_presence_of :name, presence: true, message: "^Please enter the site url!"
  validates_uniqueness_of :name, :case_sensitive => false, :allow_blank => true, message: "^Site already exists!"
  
  validates_length_of :code, :in => 1..5, :allow_blank => true
  validates_uniqueness_of :code, :case_sensitive => false, :allow_blank => true, message: "^Code already exists!"
  
  def self.check_valid_analytic_id
    where.not(ga_profile_id: nil)
  end


  def self.own_site(user_id)   #different method used in monthly_report
        find_user_site = ClientUser.where(user_id: user_id)

        if find_user_site
            return client_sites = find_user_site.map{|x| x.client_id}
        end
  end


end
