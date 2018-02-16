class PasswordResetsController < ApplicationController
    
    skip_before_action :authorize
    before_action :get_user, only: [:edit, :update]
    before_action :check_expiration, only: [:edit, :update]
    layout "login_layout"
    
    def new
        
    end
    
    def create
         @user = User.find_by(email: params[:password_reset][:email].downcase, status: 1)
         
         if @user
             @user.create_reset_digest
             
             Resque.enqueue(PasswordReset, @user.id)
            flash[:notice] = "Email sent with password reset instruction!"
            redirect_to '/reset-password'
        elsif params[:password_reset][:email].empty?
            flash[:alert] = "Email can't be empty!"
            redirect_to '/reset-password'
        else
            flash[:alert] = "<b>Error </b> : Email not found!"
            redirect_to '/reset-password'   
        end
    end
    
    
    def edit
       
    end
    
    def update
        
        @user.reset_token = nil
        @user.token_sent_at = nil
        
      if params[:user][:password].empty?
        @user.errors.add(:password, "can't be empty")
        render 'edit' 
      elsif @user.update_attributes(password_params)
        flash[:notice] = "Password has been reset."
	    redirect_to "/account-login"
      else
        flash[:alert] = "Something went wrong!"
        render 'edit'
      end
        
    end
    
    private
    
    def get_user
       @user = User.find_by(reset_token: params[:id], email: params[:email].downcase, status: 1) 
    end
    
    def password_params
        params.require(:user).permit(:password, :password_confirmation)
    end
    
    def check_expiration
        if @user.password_reset_expired?
            flash[:alert] = "Password reset token has expired."
            redirect_to "/reset-password"
         end
    end
    
end
