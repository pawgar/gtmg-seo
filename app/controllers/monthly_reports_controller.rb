class MonthlyReportsController < ApplicationController
 
 layout "admin_layout", except: [:view_pdf]

 before_action :admin_only, except: [:cl_index, :pdf, :view_pdf]

  def cl_index
  	if (params[:client] and params["report-date"])
  		if MonthlyReport.own_site(@session_user_info.id).include?(params[:client].to_i)
  			@report_file = MonthlyReport.where("client_id = ? and YEAR(date) = ? and MONTH(date) = ?", MonthlyReport.own_site(@session_user_info.id).select{|x| x == params[:client].to_i }, params["report-date"].to_date.year, params["report-date"].to_date.month)
  							.includes(:client)
  							.order('date DESC')
  							.page(params[:page]).per(50)
  		end

  	elsif (params[:client] and !params["report-date"])
  		if MonthlyReport.own_site(@session_user_info.id).include?(params[:client].to_i)
  			@report_file = MonthlyReport.where(client_id: MonthlyReport.own_site(@session_user_info.id).select{|x| x == params[:client].to_i })
  							.includes(:client)
  							.order('date DESC')
  							.page(params[:page]).per(50)
  		end

  	elsif (!params[:client] and params["report-date"])
  			@report_file = MonthlyReport.where(client_id: MonthlyReport.own_site(@session_user_info.id)).where("YEAR(date) = ? and MONTH(date) = ?", params["report-date"].to_date.year, params["report-date"].to_date.month)
  							.includes(:client)
  							.order('date DESC')
  							.page(params[:page]).per(50)
  	else
  		@report_file = MonthlyReport.where(client_id: MonthlyReport.own_site(@session_user_info.id))
  						  	.includes(:client)
  							.order('date DESC')
  							.page(params[:page]).per(50)
  	end	

  end


  def index
  	
  	if (params[:client] and params["report-date"])

  		@client = params[:client].to_i
  		@report_date = params["report-date"]

  		@report_file = MonthlyReport.where("client_id = ? and YEAR(date) = ? and MONTH(date) = ?", @client, @report_date.to_date.year, @report_date.to_date.month)
  							.includes(:client)
  							.order('date DESC')
  							.page(params[:page]).per(50)

  	elsif (params[:client] and !params["report-date"])
  		@client = params[:client]
  		@report_file = MonthlyReport.where(client_id: @client)
  							.includes(:client)
  							.order('date DESC')
  							.page(params[:page]).per(50)

  	elsif (!params[:client] and params["report-date"])

  		@report_date = params["report-date"]
  		@report_file = MonthlyReport.where("YEAR(date) = ? and MONTH(date) = ?", @report_date.to_date.year, @report_date.to_date.month)
  							.includes(:client)
  							.order('date DESC')
  							.page(params[:page]).per(50)

  	else
  		@report_file = MonthlyReport.all
  							.includes(:client)
  							.order('date DESC')
  							.page(params[:page]).per(50)
  	end

  end

  def import_report
  	@report_file = MonthlyReport.new
  end

  def create
  	@report_file = MonthlyReport.new(report_file_params)
		respond_to do |format|

		      if @report_file.save(report_file_params)
		      	format.html { redirect_to monthly_reports_path, notice: "Report has been added!" }
		        format.json { render json: @report_file, status: :created, location: monthly_reports_path }
		        format.js
		      else
		      	format.html { render action: "import_report" }
		        format.json { render json: @report_file.errors.full_messages,
		                                   status: :unprocessable_entity }
		      end
		end  		
  end


  def destroy
    	monthly_report = MonthlyReport.find(params[:id])

        monthly_report.destroy
        respond_to do |format|
        	
        	flash[:notice] = 'Report has been removed!' 
            format.html { redirect_back(fallback_location: root_path) }
            format.json { head :no_content }
        end
  end

def pdf
  
	if @session_user_info.Client?

		if MonthlyReport.own_site(@session_user_info.id).include?(MonthlyReport.find(params[:id]).client_id)

				@document = MonthlyReport.find(params[:id])

			if @document.present?
				  	data = open(@document.report_file.expiring_url)
				  	send_data data.read, filename: @document.report_file_file_name, type: @document.report_file_content_type, disposition: 'attachment'
			else
				redirect_to monthly_report_path(error: "File not found!")
			end
		else
			redirect_to monthly_report_path(error: "Please select a valid site!")
		end

	elsif @session_user_info.Administrator?
			@document = MonthlyReport.find(params[:id])

			if @document.present?
			  data = open(@document.report_file.expiring_url)
			  send_data data.read, filename: @document.report_file_file_name, type: @document.report_file_content_type, disposition: 'attachment'
			end
	end

end

def view_pdf

	if @session_user_info.Client?

		if MonthlyReport.own_site(@session_user_info.id).include?(MonthlyReport.find(params[:id]).client_id)
			@pdf_file = MonthlyReport.find(params[:id])
		else
			flash[:notice] = 'Error loading file!' 
			redirect_back(fallback_location: monthly_report_path)
		end

	elsif @session_user_info.Administrator?
		@pdf_file = MonthlyReport.find(params[:id])
	end

  render layout: "view_pdf_layout"
end



private

  def report_file_params
      params.require(:monthly_report).permit(:client_id, :date, :report_file)
  end


end
