class StrategyOffpageCategoriesController < ApplicationController

  before_action :admin_only


  def new
  	 @strat_category = StrategyOffpageCategory.new
  end

  def create
     @strat_category = StrategyOffpageCategory.new(strat_cat_params)
  	 

  		respond_to do |format|
  
  		      if @strat_category.save
  		        format.json { head :no_content }
  		        format.js { flash.now[:notice] = "Added successfully." }
  		      else
  		        format.json { render json: @strat_category.errors.full_messages, status: :unprocessable_entity }
  		      end
  		end
  end

  def destroy
    
    @strat_category = StrategyOffpageCategory.find_by(strategy_id: params[:id], offpage_category_id: params[:category])
    @strat_category.destroy

    respond_to do |format|
      format.json { head :no_content }
      format.js { flash.now[:notice] = "Offpage Category successfully unassigned!" }
    end
  end


private

	def strat_cat_params
		params.require(:strategy_offpage_category).permit(:offpage_category_id, :strategy_id)
	end

end

