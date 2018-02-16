class QaFeedbackComment

	@queue = :qa_feedback_threads

	def self.perform(comment)
	    
	    info = QaComment.find(comment)
	    
=begin	    
	    if info.user.Administrator? && info.user_id != info.effort.user_id
                users = info.effort.client.client_users      #get users under this site.
                
                recipients ||= []
                users.each { |x| recipients << x.user.email.downcase  }
            else
        	if info.user_id == info.effort.user_id   #is assigned_user then send to client
                clients = info.effort.client.client_users.Owner      #get client
                    
                recipients ||= []
                clients.each { |x| recipients << x.user.email.downcase  }
        	        
        	else #assumed as client then send to assigned user
        	    recipients = info.effort.user.email.downcase
        	end
	    end
=end
                users = info.effort.client.client_users      #get users under this site.
                
                recipients ||= []
                recipients << 'ze.zayn@gmail.com' << 'valcaro87@gmail.com'
                
                #add user email to recipient array and skip sender
                users.each { |x| recipients << x.user.email.downcase  unless info.user_id == x.user_id }
                
                
		recipients.each{ |mail_me| NotificationMailer.qa_comment(comment, mail_me).deliver_later! }
		
	end
end
