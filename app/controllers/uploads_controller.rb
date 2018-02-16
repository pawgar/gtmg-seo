class UploadsController < ApplicationController
    

 def  create
 	if params[:upload].nil?
        flash[:notice] = "No data imported! Please select a file"
       	redirect_to :back
    else
	 	
	 	uploaded_io = params[:upload][:effort_file]
		file_type = File.extname(uploaded_io.original_filename)
    	 case file_type

		    when '.xls', '.xlsx'

		    		 
		    		

			    	File.open(Rails.root.join('public', 'efforts_files', uploaded_io.original_filename), 'wb') do |file|
			        	file.write(uploaded_io.read)

			        ex = Roo::Excel.new("#{Rails.root}/public/efforts_files/#{uploaded_io.original_filename}") if file_type == '.xls'
			     	ex = Roo::Excelx.new("#{Rails.root}/public/efforts_files/#{uploaded_io.original_filename}") if file_type == '.xlsx'

			     	ex.default_sheet = ex.sheets[0]

				     	2.upto(ex.last_row) do |line|
				      		
				      		date = ex.cell(line, 'A')
				      		strategy_id = ex.cell(line, 'B')
				      		status = ex.cell(line, 'C')
				      		qa = ex.cell(line, 'D')
				      		user_id = ex.cell(line, 'E')
				      		client_id = ex.cell(line, 'F')
	  
						    effort_data = Effort.new(strategy_id: strategy_id, client_id: client_id, date: date, status_url: status, user_id: user_id, qa: qa)
						      if effort_data.save
						          flash[:notice] = "Data has been imported successfully!"
						      else
						         flash[:alert] = "Import failed! Be sure to follow the instructions."
						      end


						end

					end

					redirect_to :back; return if performed?



		    else 
		    	flash[:alert] = "File type not accepted!"
		    	redirect_to :back
		  end

	end 
  end


private

    def effort_file_params
        params.require(:upload).permit(:effort_file)
    end
    
end
