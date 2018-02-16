class QaCommentsController < ApplicationController
  
  before_action :authorize, except: [:save_incoming]
  skip_before_filter :verify_authenticity_token, only: [:save_incoming]
  
  layout "admin_layout"
   
  def index
    @effort_feedback = Effort.find(params[:effort_id])
    @comments = QaComment.where(effort: params[:effort_id])
    @new_comment = QaComment.new
  end
  
  def create
    @effort_feedback = Effort.find(params[:effort_id])
    @comments = QaComment.where(effort: params[:effort_id])
    @new_comment = QaComment.new(qa_comments_params)
    @new_comment.user_id = @session_user_info.id
    @new_comment.effort_id = params[:effort_id]
  		respond_to do |format|
  		  
  		      if @new_comment.save
  		          Resque.enqueue(QaFeedbackComment, @new_comment.id)
  		          format.json { head :no_content }
  		          format.js { flash.now[:notice] = "Added successfully." }
  		      else
  		        format.json { render json: @new_comment.errors.full_messages, status: :unprocessable_entity }
  		        #format.js { render json: @client.errors.full_messages, status: :unprocessable_entity }
  		      end
  		end
  		
  end
  
  def save_incoming
      flash["notice"] = "yeah"
      
      
      token = params["recipient"]
      comment = params["stripped-text"]
      
      sender = User.find_by(email: params["sender"])
      effort = Effort.find_by(feedback_token: token.strip[/\-(.*?)@/,1])
      
      
      new_comment = QaComment.new
      new_comment.effort_id = effort.id
      new_comment.user_id   = sender.id
      new_comment.comment   = params["stripped-text"]
      
      if new_comment.save
        Resque.enqueue(QaFeedbackComment, new_comment.id)
      end
      
      render :text => 'OK'
      
  end

private

  def qa_comments_params
      params.require(:qa_comment).permit(:effort_id, :user_id, :comment)
  end
end
