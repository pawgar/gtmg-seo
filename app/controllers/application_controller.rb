class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  before_action :authorize
  
  
  def authorize
      @session_user_info = User.find_by(id: session[:user_id])
    
    unless @session_user_info
      redirect_to '/account-login', alert: "<b>Error</b>: Please login to continue!"
    end
  end
  
  
  def check_session
    if session[:user_id].present?
      redirect_to '/dashboard'
    end
  end
  
  
  def check_user_type
      
  end
  
  def admin_only
      unless @session_user_info.Administrator?
        redirect_to root_path, :alert => "Access denied" 
      end
  end
  
  def client_only
      unless @session_user_info.Client?
        redirect_to dashboard_path
      end
  end
  

  def verify_client_site
    
      if @session_user_info.clients.empty?
          flash[:openModal] = "Please add a site to continue!"
          redirect_to dashboard_path
      end
  end
  
  
end
