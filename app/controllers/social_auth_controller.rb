class SocialAuthController < ApplicationController
  
  skip_before_action :authorize
  
  def create
    auth = request.env["omniauth.auth"]
    
    if auth['extra']['raw_info']['email'].present? or auth['info'].email.present?
    	 			process_auth(auth)
    else
    	 		flash[:alert] = "Unable to fetch email from your #{auth['provider']} account!"
    	 		redirect_to :back 
    end
	 	
  end
  
  
  private
  
  def process_auth(auth)
    authentication = SocialAuth.find_by_provider_and_uid(auth['provider'], auth['uid'])
    
    if authentication
      # Authentication found, sign the user in.
      user = User.find(authentication.user_id)
      session[:user_id] = user.id
      flash[:notice] = "Signed in successfully."
      redirect_to "/dashboard"
      
    else
      # Check user table for existing email
			existing_user_through_email = User.find_by(email: auth['info'].email)
      
        if existing_user_through_email
  
  			 		# Register new provider associated through existing email.
  			 		new_provider = SocialAuth.new
  			 	 	new_provider.apply_omniauth_existing_user(auth, existing_user_through_email)

            session[:user_id] = existing_user_through_email.id
    
    			  flash[:notice] = "Signed in successfully!"
    			  redirect_to '/dashboard'

			 	else
  			 		# Authentication not found and email does not exist in user table, thus a new user.
  					user = User.new
				    
				    user.apply_omniauth(auth)

				    if user.save(:validate => true)

				    	find_user = User.find(user.id)
				    	session[:user_id] = user.id
				   		
				   		#Resque.enqueue(MailSender, find_user.id)
				   		flash[:notice] = "Account created and signed in successfully!"
				   		redirect_to '/dashboard'

				    else
        
					    flash[:alert] = "Error while creating account. Please try again! <br/>
					                    <small>#{user.errors.full_messages.join("<br/>")}</small>"
					    redirect_to :back
				    end			 	  
        
        end
    
    end
  
  end
  
end


