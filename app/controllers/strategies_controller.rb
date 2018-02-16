class StrategiesController < ApplicationController
  
  require 'roo'
  require 'tempfile'
  
  before_action :admin_only, except: [:index]
  
  layout "admin_layout"
  
  
  def index
    @strategies = Strategy.includes(:offpage_categories).order(id: :asc)
  end

  def new
    @strategy = Strategy.new
  end

  def create
     @strategy = Strategy.new(strat_params)
  
  		respond_to do |format|
  
  		      if @strategy.save
  		        #redirect_to :back
  		      	#format.html { redirect_to user_path(@client.user_id), notice: "Note updated." }
  		      	#format.html { redirect_to @user, notice: "Avatar has been updated!" }
  		        #format.json { render json: @client, status: :created, location: user_path(@client.user_id) }
  		        format.json { head :no_content }
  		        format.js { flash.now[:notice] = "Added successfully." }
  		      else
  		      	#format.html { render action: "show" }
  		        format.json { render json: @strategy.errors.full_messages, status: :unprocessable_entity }
  		        #format.js { render json: @client.errors.full_messages, status: :unprocessable_entity }
  		      end
  		end
  end
  
  def show
    @strategy = Strategy.find(params[:id])
  end

  def edit
    @strategy = Strategy.find(params[:id])
  end

  def update
    @strategy = Strategy.find(params[:id])
  		respond_to do |format|
  
  		      if @strategy.update(strat_params)
  		        format.json { head :no_content }
  		        format.js { flash.now[:notice] = "Updated successfully." }
  		      else
  		        format.json { render json: @strategy.errors.full_messages, status: :unprocessable_entity }
  		      end
  		end  
  end

  
  def destroy
    strategy = Strategy.find(params[:id])
    strategy.destroy
    respond_to do |format|
      format.html { redirect_to :back, notice: 'Strategy deleted successfully!' }
      format.json { head :no_content }
    end
  end
  
  def import_strategy_form

  end
  
  def import_strategy_file
	  uploaded_io = params[:strategy_file]
	  
	  xlsx = Roo::Excelx.new(uploaded_io)
	  
	  xlsx.default_sheet = xlsx.sheets[0]
	  
	  2.upto(12) do |line|
	    type_p = xlsx.cell(line, 'A')
	    
	     proo = Strategy.new(code: type_p, description: type_p)
						      if proo.save
						          flash[:notice] = "Data has been imported successfully!"
						      else
						         flash[:notice] = "Import failed! Be sure to follow the instructions."
						      end
						      
	  end
	  
		redirect_to :back; return if performed?
		
  end
  
  private
  
  def strat_params
    params.require(:strategy).permit(:code, :description, :notes)
  end
  
  
  
  
end
