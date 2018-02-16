class OffpageCategoriesController < ApplicationController
  layout "admin_layout"

  before_action :admin_only

  def index
  	 @offpage_cat = OffpageCategory.order(code_letter: :asc)
  end


  def new
    @offpage_cat = OffpageCategory.new
  end

  def create
     @offpage_cat = OffpageCategory.new(category_params)
  
  		respond_to do |format|
  
  		      if @offpage_cat.save
  		        format.json { head :no_content }
  		        format.js { flash.now[:notice] = "Added successfully." }
  		      else
  		        format.json { render json: @offpage_cat.errors.full_messages, status: :unprocessable_entity }
  		      end
  		end
  end

  def edit
    @offpage_cat = OffpageCategory.find(params[:id])
  end

  def update
    @offpage_cat = OffpageCategory.find(params[:id])
  		respond_to do |format|
  
  		      if @offpage_cat.update(category_params)
  		        format.json { head :no_content }
  		        format.js { flash.now[:notice] = "Updated successfully." }
  		      else
  		        format.json { render json: @offpage_cat.errors.full_messages, status: :unprocessable_entity }
  		      end
  		end  
  end

  
  def destroy
    category = OffpageCategory.find(params[:id])
    category.destroy
    respond_to do |format|
      format.html { redirect_to :back, notice: 'Category deleted successfully!' }
      format.json { head :no_content }
    end
  end



private

	def category_params
		params.require(:offpage_category).permit(:code_letter, :category_name)
	end


end
