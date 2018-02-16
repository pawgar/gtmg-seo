class ClientsController < ApplicationController
  before_action :admin_only, except: [:new_site, :create_cl, :edit_cl, :update_cl, :show_note_cl, :destroy_cl]

  layout "admin_layout"
  
  def index
      @clients = Client.order("name ASC")
    # @clients = 
    #   @featured_ads = Ad.joins("LEFT JOIN categories ON categories.id = ads.category_id 
    # LEFT JOIN photosads ON photosads.ad_id = ads.id")
    # .select("ads.*,categories.name as category_name, photosads.filename")
    # .where("ads.featured=1")
    # .group("ads.id")
    # .order("ads.id DESC")
    # .limit(8)
  end
  
  def new
    @client = Client.new
    @is_remote = true
  end

  def new_site
    @client = Client.new
    @action = "create_cl"
  end
  
  def create_cl
    @mySite = User.find(@session_user_info.id)
    @client = Client.new(client_params)
    @action = "create_cl"            
  		respond_to do |format|
  
  		      if @client.save
  		        
              save_to_ClientUser = ClientUser.new
                save_to_ClientUser.user_id = @session_user_info.id
                save_to_ClientUser.client_id = @client.id
                save_to_ClientUser.user_role = 1               #[1:owner]
              save_to_ClientUser.save
              
  		        format.json { head :no_content }
  		        format.js { flash.now[:notice] = "Added successfully." }
  		      else
  		      	#format.html { render action: "show" }
  		        format.json { render json: @client.errors.full_messages, status: :unprocessable_entity }
  		        #format.js { render json: @client.errors.full_messages, status: :unprocessable_entity }
  		      end
  		end
  		
  end
  

  def edit_cl
      client_user = ClientUser.find_by(user_id: @session_user_info.id, client_id: params[:id])
      @client = client_user.client
      @action = "update_cl"
  end
  
  def update_cl
     client_user = ClientUser.find_by(user_id: @session_user_info.id, client_id: params[:id])
     @client = client_user.client
     @action = "update_cl"
  		respond_to do |format|
  
  		      if @client.update(client_params)
  		        format.json { head :no_content }
  		        format.js { flash.now[:notice] = "Updated successfully." }
  		      else
  		        format.json { render json: @client.errors.full_messages, status: :unprocessable_entity }
  		      end
  		end    
  end
 
  def show_note_cl
     client_user = ClientUser.find_by(user_id: @session_user_info.id, client_id: params[:id])
     @client = client_user.client
  end
  
  def destroy_cl
    
    client_user = ClientUser.find_by(user_id: @session_user_info.id, client_id: params[:id])
    @client = client_user.client
    
    if @client.destroy
       flash[:notice] = "Client Deleted."
       redirect_to "/dashboard"
    end
  end
  
  def create
    @client = Client.new(client_params)

  		respond_to do |format|
  
  		      if @client.save
  		        #redirect_to :back
  		      	#format.html { redirect_to user_path(@client.user_id), notice: "Note updated." }
  		      	#format.html { redirect_to @user, notice: "Avatar has been updated!" }
  		        #format.json { render json: @client, status: :created, location: user_path(@client.user_id) }
  		        format.json { head :no_content }
  		        format.js { flash.now[:notice] = "Client's website was successfully created." }
  		      else
  		      	#format.html { render action: "show" }
  		        format.json { render json: @client.errors.full_messages, status: :unprocessable_entity }
  		        #format.js { render json: @client.errors.full_messages, status: :unprocessable_entity }
  		      end
  		end
  end

  
  def show
    @client = Client.includes(:client_users, :users).find(params[:id])
    @is_remote = false
    #@client_users = ClientUser.joins("LEFT JOIN users u ON u.id = client_users.user_id").select("u.*, client_users.*").order("u.id DESC").where("client_users.client_id=#{client_id}")
  end
  
  def update
    @client = Client.find(params[:id])
    if @client.update_attributes(client_params)
      flash[:notice] = "Client Updated Successfully"
      redirect_to client_path(@client.id)
    else
      render 'show'
    end
  end
  
  def destroy
    ClientUser.delete_all(client_id: params[:id])
    @client = Client.find(params[:id])
    
    if @client.destroy
       flash[:notice] = "Client Deleted."
       redirect_to clients_path
    end
  end
  
  def assign_user
    client_id = params[:client][:client_id]
    user_id = params[:user][:user_id]
    
    @client_users = ClientUser.new
    @client_users.user_id = user_id
    @client_users.client_id = client_id
   
    if user_id.blank?
      redirect_to client_path(client_id), alert: "Please select a user."
    elsif ClientUser.exists?(client_id: client_id, user_id: user_id)
      redirect_to client_path(client_id), alert: "User already exist."
    elsif @client_users.save
      redirect_to client_path(client_id), notice: "User successfully assigned."
    else
      redirect_to client_path(client_id), alert: "There was an error in assigning a user!"
    end
      
  end
  
  def delete_assigned_user
    
    @client_user = ClientUser.find(params[:id])
    if @client_user.destroy
       flash[:notice] = "User was unassigned."
       redirect_to client_path(@client_user.client_id)
    end
  end
  
  
  def add_notes
      @client = Client.find_by(user_id: params[:id])
  end

  def create_notes
    	@client = Client.find_by(user_id: params[:id])
  
  
  		respond_to do |format|
  
  
  		      if @client.update_attributes(note_param)
  		        #redirect_to :back
  		      	#format.html { redirect_to user_path(@client.user_id), notice: "Note updated." }
  		      	#format.html { redirect_to @user, notice: "Avatar has been updated!" }
  		        #format.json { render json: @client, status: :created, location: user_path(@client.user_id) }
  		        format.json { head :no_content }
  		        format.js { flash.now[:notice] = "Note has been added." }
  		      else
  		      	#format.html { render action: "show" }
  		        format.json { render json: @client.errors.full_messages, status: :unprocessable_entity }
  		        #format.js { render json: @client.errors.full_messages, status: :unprocessable_entity }
  		      end
  		end
  end
  
  
  private
  
  def client_params
    params.require(:client).permit(:name, :code, :ga_profile_id, :notes)
  end
  
  
  def note_param
    params.require(:client).permit(:notes)
  end
end
