class NotificationMailer < ApplicationMailer

	
    def password_reset(user)
       @user_info = User.find(user)
       mail(to: @user_info.email, subject: "Password Reset")
    end
    
    def qa_comment(comment, mail_me)
        @info = QaComment.find(comment)
        
        mail(
            to: mail_me, from: "#{@info.user.fullname + ' -GTMG SEO Tools- '} <notifications@globaltechmarketinggroup.com>", 
            reply_to: "notifications-#{@info.effort.feedback_token}@inbound-seo.globaltechmarketinggroup.com",
            subject: @info.effort.qa.titleize
            )
    end


end
