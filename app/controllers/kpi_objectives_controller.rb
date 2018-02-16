class KpiObjectivesController < ApplicationController
    
    before_action :admin_only
    layout "admin_layout"
    autocomplete :kpi_objective, :title, :full => true
    #before_filter :check_changes, only: [:update]



    def index
    	@kpi_objectives = KpiObjective.all.order("title ASC")
    end


    def show

    end

    def new
    	@kpi_objective = KpiObjective.new
    end


    def create
    	@kpi_objective = KpiObjective.new(objective_params)

    	respond_to do |format|
    		if @kpi_objective.save
    			format.js { flash.now[:notice] = "Record added!"}
    		else
    			format.json { render json: @kpi_objective.errors.full_messages, status: :unprocessable_entity }
    		end
    	end
    end

    def edit
    	@kpi_objective = KpiObjective.find(params[:id])
    end

    def  update
    	@kpi_objective = KpiObjective.find(params[:id])
    	@kpi_objective.assign_attributes(objective_params)

            respond_to do |format|
	            if @kpi_objective.changed?
	            	if @kpi_objective.save
	  		        	format.json { head :no_content }
	  		        	format.js { flash.now[:notice] = "Updated successfully." }

	  		        else
	  		        	format.json { render json: @kpi_objective.errors.full_messages, status: :unprocessable_entity }
	  		        end

	            else
	            	@kpi_objective.errors.add(:base, "No changes made!")
	            	format.json { render json: @kpi_objective.errors.full_messages, status: :unprocessable_entity }
	  		    end

  		    end  
    end

    def destroy
    	kpi_objective = KpiObjective.find(params[:id])

        kpi_objective.destroy
        respond_to do |format|
        	flash[:notice] = 'Record deleted successfully!' 
            format.html { redirect_back(fallback_location: root_path) }
            format.json { head :no_content }
        end
    end



private
	
	def check_changes
		if @kpi_objective.title.changed?
			@kpi_objective.errors.add(:base, "^No changes has been made!")
		end
	end

	def objective_params
		params.require(:kpi_objective).permit(:title)
	end


end
