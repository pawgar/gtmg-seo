class UsersController < ApplicationController
  
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :authorize, except: [:client_registration, :create_client]
  before_action :admin_only, except: [:show, :update, :client_registration, :create_client, :change_avatar, :update_avatar]    #change user_params for clients on update
  
  
  layout "admin_layout"

  def index
    @users = User.order("firstname ASC").page(params[:page]).per(20)
  end


  def show
  end


  def new
    @user = User.new
  end


  def edit
  end


  def create
    @user = User.new(user_params)


      if @user.save
        redirect_to @user, notice: 'User was successfully created.'
      else
        flash[:alert] = "There was an error while creating new account!"
        render :new
      end
  end
  
  def client_registration
    @user = User.new
    render layout: "login_layout"
  end
  
  def create_client
    @user = User.new(user_params)
      if @user.save
        redirect_to '/account-login', notice: 'You have been successfully registered. Please login to continue.'
      else
        flash[:alert] = "There was an error while creating your account!<br/>
					                    <small>#{@user.errors.full_messages.join("<br/>")}</small>"
        render :client_registration, layout: "login_layout"
      end
      
  end


  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        flash[:alert] = "There was an error while updating user info!"
        format.html { render :show }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end


  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to :back, notice: 'User was successfully removed.' }
      format.json { head :no_content }
    end
  end
  
  def change_avatar
		@user = User.find(params[:id])
  end

	def update_avatar
		@user = User.find(params[:id])

		@user.skip_password_validation = true


		respond_to do |format|


		      if @user.update_attributes(user_avatar_params)
		      	format.html { redirect_to @user, notice: "Avatar has been updated!" }
		        format.json { render json: @user, status: :created, location: @user }
		        format.js
		      else
		      	#format.html { render action: "show" }
		        format.json { render json: @user.errors.full_messages,
		                                   status: :unprocessable_entity }
		      end
		end
	end
	
	

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:firstname, :lastname, :password, :password_confirmation, :email, :status, :role)
    end
    
    def user_avatar_params
      params.require(:user).permit(:avatar)
    end
    
end
