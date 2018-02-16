class TechnicalStrategiesController < ApplicationController

  before_action :admin_only
  
  layout "admin_layout"
  

    def index
        @tech_strategy = TechnicalStrategy.order(id: :asc)
    end
    
    def new
        @tech_strategy = TechnicalStrategy.new
    end
    
    def create
        @tech_strategy = TechnicalStrategy.new(tech_strat_params)
  
      		respond_to do |format|
      
      		      if @tech_strategy.save
      		        #redirect_to :back
      		      	#format.html { redirect_to user_path(@client.user_id), notice: "Note updated." }
      		      	#format.html { redirect_to @user, notice: "Avatar has been updated!" }
      		        #format.json { render json: @client, status: :created, location: user_path(@client.user_id) }
      		        format.json { head :no_content }
      		        format.js { flash.now[:notice] = "Added successfully." }
      		      else
      		      	#format.html { render action: "show" }
      		        format.json { render json: @tech_strategy.errors.full_messages, status: :unprocessable_entity }
      		        #format.js { render json: @client.errors.full_messages, status: :unprocessable_entity }
      		      end
      		end
    end
    
    def edit
        @tech_strategy = TechnicalStrategy.find(params[:id])
    end

    def update
        @tech_strategy = TechnicalStrategy.find(params[:id])
            respond_to do |format|
  
              if @tech_strategy.update(tech_strat_params)
  		            format.json { head :no_content }
  		            format.js { flash.now[:notice] = "Updated successfully." }
  		        else
  		            format.json { render json: @tech_strategy.errors.full_messages, status: :unprocessable_entity }
  		        end
  		    end  
    end

  
    def destroy
        tech_strategy = TechnicalStrategy.find(params[:id])
          tech_strategy.destroy
          respond_to do |format|
              format.html { redirect_to :back, notice: 'Record deleted successfully!' }
              format.json { head :no_content }
          end
    end


private

    def tech_strat_params
        params.require(:technical_strategy).permit(:description, :notes)
    end
end
