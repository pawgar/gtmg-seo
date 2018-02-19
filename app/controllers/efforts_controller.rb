class EffortsController < ApplicationController
  
  layout "admin_layout"
  before_action :verify_client_site, only: [:cl_index]
  before_action :admin_only, except: [:cl_index]
  before_action :check_efforts_table, only: [:index]
  before_action :restrict_own_site, only: [:cl_index]


  def index

    if ( params[:client] and (!params[:start_date] and !params[:end_date]) )
            
       effort_i = Effort.includes(:user).search(params[:client]).includes(:client, :user, {strategy: [:offpage_categories]}, :qa_comments)
        @effort = effort_i.order('date DESC', 'strategies.id ASC').page(params[:page]).per(20)

     client_name = ( effort_i.first.present? ? effort_i.first.client.name : Client.find(params[:client]).name )
     flash.now[:notice] = "Showing result for '<i><b>#{client_name}</b></i>'".html_safe
     @header_title = client_name

      @effCount = effort_i.count
      effort_pdf = effort_i.limit(260).order('date ASC', 'strategies.id ASC')


    elsif (params[:client] and (params[:start_date] or params[:end_date]) )

        date_check(params[:start_date] ||= nil, params[:end_date] ||= nil)
 
       effort_i = Effort.get_range(params[:client], params[:start_date], params[:end_date]).includes(:client, :user, {strategy: [:offpage_categories]}, :qa_comments)
        @effort = effort_i.order('date DESC', 'strategies.id ASC').page(params[:page]).per(20)

     client_name = ( effort_i.first.present? ? effort_i.first.client.name : Client.find(params[:client]).name )
     flash.now[:notice] = "Showing result for '<i><b>#{client_name}</b></i>' from '#{@start_date} to #{@end_date}'".html_safe
     @header_title = client_name

      @effCount = effort_i.count
      effort_pdf = effort_i.limit(260).order('date ASC', 'strategies.id ASC')

    elsif (!params[:client] and (params[:start_date] or params[:end_date]) )

       date_check(params[:start_date] ||= nil, params[:end_date] ||= nil)
 
       effort_i = Effort.get_range_all(params[:start_date], params[:end_date]).includes(:client, :user, {strategy: [:offpage_categories]}, :qa_comments)
        @effort = effort_i.order('date DESC', 'strategies.id ASC').page(params[:page]).per(200)
        flash.now[:notice] = "Showing result for all data from '#{@start_date} to #{@end_date}'".html_safe
     @header_title = ""

      @effCount = effort_i.count
      effort_pdf = effort_i.limit(260).order('date ASC', 'strategies.id ASC')
      
    else
       effort_i = Effort.includes(:client, :user, {strategy: [:offpage_categories]}, :qa_comments)

        @effort = effort_i.order('date DESC', 'clients.name ASC').page(params[:page]).per(200)
        flash.now[:notice] = "Showing result for all data.".html_safe

      @effCount = effort_i.count
      effort_pdf = effort_i.limit(260).order('date ASC', 'strategies.id ASC')
    end
    
    pdf_blows(effort_pdf)
  end
  
  def cl_index
    
    @upload = Upload.new
    @mySite = User.find(@session_user_info.id)
    
    if params[:client] and (!params[:start_date] and !params[:end_date])
      client_name = Client.find(params[:client]).name
      
      flash.now[:notice] = "Showing result for '<i><b>#{client_name}</b></i>'".html_safe
      effort_i = Effort.includes(:user).search(params[:client]).includes(:client, :user, {strategy: [:offpage_categories]}, :qa_comments)
       @effort = effort_i.order('date DESC', 'strategies.id ASC').page(params[:page]).per(20)
     @effCount = effort_i.count
    effort_pdf = effort_i.limit(260).order('date ASC', 'strategies.id ASC')

      @header_title = client_name
      
    elsif params[:client] and params[:start_date] or params[:end_date]
      client_name = Client.find(params[:client]).name

      if params[:start_date] and params[:end_date]
        if params[:start_date] > params[:end_date]
            @start_date = params[:start_date]
            @end_date   = (DateTime.now.to_date).strftime('%Y-%m-%d')
        else
            @start_date = params[:start_date]
            @end_date   = params[:end_date]
        end
      elsif !params[:start_date] and params[:end_date] 
            @start_date = (params[:end_date].to_date - 5).strftime('%Y-%m-%d')
            @end_date   = params[:end_date]  
      elsif params[:start_date] and !params[:end_date] 
            @start_date = params[:start_date]
            @end_date   = (DateTime.now.to_date).strftime('%Y-%m-%d')
      end
      
      flash.now[:notice] = "Showing result for '<i><b>#{client_name}</b></i>' from '#{@start_date} to #{@end_date}' ".html_safe
      effort_i = Effort.get_range(params[:client], params[:start_date], params[:end_date]).includes(:client, :user, {strategy: [:offpage_categories]}, :qa_comments)
      @effCount = effort_i.count
        @effort = effort_i.order('date DESC', 'strategies.id ASC').page(params[:page]).per(20)
     effort_pdf = effort_i.limit(260).order('date ASC', 'strategies.id ASC')

      @header_title = client_name
    else
        effort_i = @mySite.clients.first.efforts.includes(:client, :user, {strategy: [:offpage_categories]}, :qa_comments)
        
        @effort = effort_i.order('date DESC', 'strategies.code ASC').page(params[:page]).per(20)
      @effCount = effort_i.count
     effort_pdf = effort_i.limit(260).order('date ASC', 'strategies.id ASC')

        @header_title = @effort.present? ? @effort.first.client.name : ''
    end

      pdf_blows(effort_pdf)

  end

  def new
    @effort = Effort.new  
    @effort.client_id = "#{params[:client]}"
  end
  
  def edit
      @effort = Effort.find(params[:id])
      @task_code = @effort.strategy
  end


  def update
     @effort = Effort.find(params[:id])
     @effort.execute_standardValidation = true
     
     task_code = Strategy.find_by(code: params[:effort][:strategy_id])
     @effort.strategy_id = (task_code.nil? ? nil : task_code.id)
     @effort.client_id   = params[:effort][:client_id]
     @effort.user_id     = params[:effort][:user_id]
     @effort.date        = params[:effort][:date]
     @effort.status_url  = params[:effort][:status_url]
     @effort.qa          = params[:effort][:qa]
        
  		respond_to do |format|
              
  		      if @effort.save
  		        format.json { head :no_content }
  		        format.js { flash.now[:notice] = "Updated successfully." }
  		      else
  		      	if params[:effort][:strategy_id].present?
  		      	  @effort.errors.add(:task_code, "^Strategy code not found!") if task_code.nil?
  		      	end
  		        format.json { render json: @effort.errors.full_messages, status: :unprocessable_entity }
  		      end
  		end    
  end
  
  def create
     @effort = Effort.new(effort_params)
     @effort.execute_standardValidation = true
     
     task_code = Strategy.find_by(code: params[:effort][:strategy_id])
     
     @effort.strategy_id = (task_code.nil? ? nil : task_code.id)
     @effort.feedback_token = generate_token
  		respond_to do |format|

  		      if @effort.save
  		        
          		if Effort.where.not(client_id: nil).count == 1  #first record
          		  format.js {render js: "window.location = '#{efforts_path}';"}
          		else
  		          format.json { head :no_content }
  		          format.js { flash.now[:notice] = "Added successfully." }
  		        end
  		      else
  		      	#format.html { render action: "show" }
  		      	if params[:effort][:strategy_id].present?
  		      	  @effort.errors.add(:task_code, "^Strategy code not found!") if task_code.nil?
  		      	end
  		        format.json { render json: @effort.errors.full_messages, status: :unprocessable_entity }
  		        #format.js { render json: @client.errors.full_messages, status: :unprocessable_entity }
  		      end
  		end
  end
  
  def show
  end
  
  def upload_effort_sheet
      
  end
  
  def upload_effort
    session[:effort_file_params] ||= {}
    @upload_effort = Effort.new(session[:effort_file_params]) 
    @upload_effort.current_step = session[:effort_upload_step]
  end
  
  def process_uploaded_effort
    
    session[:effort_file_params].deep_merge!(params[:effort]) if params[:effort]
    session[:effort_file_params].deep_merge!(params[:file_info]) if params[:file_info]
    
    if params[:upload].present?
        if params[:upload][:file].present?
          #@upload_effort.check_file_type(params[:upload][:file])
          
      	 	name = params[:upload][:file].original_filename
      	 	directory = "public/upload/efforts"
      	 	path = File.join(directory, name)
      	  ext_name = File.extname(name)
      	 	File.open(path, "wb") { |f| f.write(params[:upload][:file].read) }
      	 	
      	 	
      	 	ab = {"file" =>{"file_name" => name, "path" => path, "file_type" => ext_name} }
    
      		session[:effort_file_params].deep_merge!(ab)
    		end
		end
		
    @upload_effort = Effort.new(session[:effort_file_params]) 
    @upload_effort.current_step = session[:effort_upload_step]
    
      if params[:back_button]
          @upload_effort.previous_step
          session[:effort_upload_step] = @upload_effort.current_step
          
      elsif @upload_effort.valid?
          if @upload_effort.last_step?
              import_data(session[:effort_file_params])
              
              session[:effort_upload_step] = nil
              session[:effort_file_params] = nil
              flash[:skipped_data] = @skipped
              redirect_to upload_effort_file_path and return
          else
              @upload_effort.next_step
          end
          
        session[:effort_upload_step] = @upload_effort.current_step
      end
      
      if @upload_effort.new_record?
        render "upload_effort"
      else
        session[:effort_upload_step] = session[:effort_file_params] = nil
        # redirect to success path
        flash[:notice] = "Data has been imported successfully!"
        redirect_to upload_effort_file_path
      end
		
  end
  
  def destroy
    
    @effort = Effort.find(params[:id])
    @effort.destroy
    respond_to do |format|
      format.html { redirect_to :back, notice: 'Effort data has been successfully removed.' }
      format.json { head :no_content }
    end
  end
  
  def no_record
    effort_record = Effort.where.not(client_id: nil).exists?
    
    if effort_record
      redirect_to efforts_path
    else
      flash.now[:alert] = "Record empty!"
      @effort = Effort.new      
    end
  end

private

  def import_data(effort_session_params)
    
                file_type      = effort_session_params["file"]["file_type"]
                file_path      = effort_session_params["file"]["path"]
                
                selected_sheet    = effort_session_params["file_data"]["selected_sheet"]
                user_id           = effort_session_params["file_data"]["user_id"].to_i
                starting_row      = effort_session_params["file_data"]["starting_row"].to_i
                end_row           = effort_session_params["file_data"]["last_row"].to_i
                date_column       = effort_session_params["file_data"]["date_column"]
                note_column       = effort_session_params["file_data"]["note_column"]
                task_code_column  = effort_session_params["file_data"]["task_code_column"]
                status_url_column = effort_session_params["file_data"]["status_url_column"]
                feed_back_column  = effort_session_params["file_data"]["feed_back_column"]

    			      ex = Roo::Excel.new("#{Rails.root}/#{ file_path} ") if file_type == '.xls'
    			     	ex = Roo::Excelx.new("#{Rails.root}/#{ file_path }") if file_type == '.xlsx'                
                
    			     	ex.default_sheet = selected_sheet
                  
                  upload_effort = []
                  upload_effort_skipped = []
                  
    				     	starting_row.upto(end_row) do |line|
                      
                      
                      col_date        = ex.cell(line, date_column)
                      col_task_code   = ex.cell(line, task_code_column)
                      
                      if col_date.present? && col_task_code.present?
        				      		#col_strategy_id = ex.cell(line, task_code_column)
        				      		
                          split_col_task_code   = col_task_code.nil? ? "" : col_task_code.split(/#|:/).first
                          split_col_client_code = col_task_code.nil? ? "" : col_task_code.split(/#|:/).last
                          
                          task_code             = Strategy.find_by(code: split_col_task_code)
                          client_code           = Client.find_by(code: split_col_client_code)
                          
                          task_code_strategy_id = task_code.nil? ? nil : task_code.id
        				      		client_site_id        = client_code.nil? ? nil : client_code.id
        				      		col_status      = ex.cell(line, status_url_column)
        				      		col_user_id     = user_id
        				      		col_note        = ex.cell(line, note_column)
        				      		col_qa          = ex.cell(line, feed_back_column)
        				      		
        				      		if task_code_strategy_id.present?
        				      	    upload_effort << Effort.new(strategy_id: task_code_strategy_id, client_id: client_site_id, date: col_date, notes: col_note, status_url: col_status, user_id: col_user_id, qa: col_qa, feedback_token: generate_token) 
        				      	  else
        				      	    #task_code_strategy_id.nil?
        				      	    upload_effort_skipped << {task_code: split_col_task_code, date: col_date}
        				      	  end
        				    end

    						  end
    						  Effort.import upload_effort, batch_size: 100
    						  @skipped = upload_effort_skipped
    						  flash[:notice] = "Data has been imported successfully! Records imported: #{upload_effort.count}"
  end
  
  def effort_params
    params.require(:effort).permit(:client_id, :user_id, :strategy_id, :date, :notes, :status_url, :qa)
  end

  def check_efforts_table
      efforts_record = Effort.where.not(client_id: nil).exists?
      
      unless efforts_record
          redirect_to empty_effort_record_path
      end
  end

  def generate_token
    token = SecureRandom.urlsafe_base64(15)
    generate_token if Effort.exists?(feedback_token: token)
    
    return token
  end
  
  def restrict_own_site
    if params[:client]
        site = params[:client].to_i
        
        find_user_site = ClientUser.find_by(user_id: @session_user_info.id, client_id: site)
        unless find_user_site
            flash[:alert] = "Site not found!"
            raise ActionController::RoutingError.new('Not Found')
        end
    end
  end

  def pdf_blows(effort_pdf)
        @eff = effort_pdf

          respond_to do |format|
              format.html
              format.pdf do
                #@tech_strat = tech_strat
                render pdf:     "Efforts-report", # Excluding ".pdf" extension.
                disposition:    'attachment', # inline
                layout:         'pdf',
                locals: { effort:  @eff},
                header: {
                    html: { template: 'layouts/pdf_header' },
                    spacing: 5
                  },
                footer: {
                    html: { template: 'layouts/pdf_footer' },
                    spacing: 1
                  },
                margin: { 
                  top: 48,
                  bottom: 20,
                  left: 0,
                  right: 0 }
              end
        end
  end 

  def date_check(start_date, end_date)
      if start_date and end_date
        if start_date > end_date
            @start_date = start_date
            @end_date   = (DateTime.now.to_date).strftime('%Y-%m-%d')
        else
            @start_date = start_date
            @end_date   = end_date
        end
      elsif !start_date and end_date
            @start_date = (end_date.to_date - 5).strftime('%Y-%m-%d')
            @end_date   = end_date
      elsif start_date and !end_date
            @start_date = start_date
            @end_date   = (DateTime.now.to_date).strftime('%Y-%m-%d')
      end
  end
  
end
