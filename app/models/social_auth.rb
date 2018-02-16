class SocialAuth < ActiveRecord::Base
   
   belongs_to :user 
   
    def apply_omniauth_existing_user(auth, existing_user_through_email)
		SocialAuth.create!(:user_id => existing_user_through_email.id, :provider => auth['provider'], :uid => auth['uid'], :token => auth['credentials']['token'])
	end
	
end
