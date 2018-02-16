class SessionsController < ApplicationController
    
    before_action :authorize, except: [:index, :user_login]
    before_action :check_session, only: [:index]
      layout "login_layout"
      
    def index
    
    end
    
    def user_login
        user = User.where(email: params[:email], status: 1).first
        
        if user && user.authenticate(params[:password])
            session[:user_id] = user.id
            redirect_to '/pages/dashboard'
        else
            flash[:alert] = "<b>Error:</b> Invalid Credentials! <a href='/reset-password'>Lost your password?</a>"
            redirect_to :back
        end
    end
    
    def user_logout
        session[:user_id] = nil
        redirect_to '/account-login', notice: "You are now logged out."
    end
    
    private
    

    
end
