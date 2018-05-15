class TechStrategyImplementationsController < ApplicationController

  before_action :admin_only, except: [:cl_index]
  before_action :restrict_own_site, only: [:cl_index]
  before_action :client_only, only: [:cl_index]
  before_action :check_tsi_table, only: [:index]
  before_action :verify_client_site, only: [:cl_index]
  
  layout "admin_layout"
  
  def index
    @mySite = User.find(@session_user_info.id)
      
    if params[:client] and (!params[:start_date] and !params[:end_date])
      client_name = Client.find(params[:client]).name
      
      flash.now[:notice] = "Showing result for '<i><b>#{client_name}</b></i>'".html_safe
      @tech_strat = TechStrategyImplementation.search(params[:client]).order("technical_strategy_id ASC").includes(:technical_strategy)
      @header_title = client_name

    elsif params[:client] and params[:start_date] or params[:end_date]
      client_name = Client.find(params[:client]).name
      
      if params[:start_date] and params[:end_date]
        if params[:start_date].to_date > params[:end_date].to_date
            flash.now[:alert] = "End date should be later than start date!"
        else
            @start_date = params[:start_date]
            @end_date   = params[:end_date]
        end
      elsif !params[:start_date] and params[:end_date] 
            @start_date = (params[:end_date].to_date - 1.month).beginning_of_month.strftime('%Y-%m-%d')
            @end_date   = params[:end_date]  
      elsif params[:start_date] and !params[:end_date] 
            @start_date = params[:start_date].to_date.strftime('%Y-%m-%d')
            @end_date   = (DateTime.now.to_date).strftime('%Y-%m-%d')
      end
      
      #flash.now[:notice] = "Showing result for '<i><b>#{client_name}</b></i>' from '#{@start_date} to #{@end_date}' ".html_safe
      @tech_strat = TechStrategyImplementation.get_range(params[:client], params[:start_date], params[:end_date]).where.not(technical_strategy_id: nil).order("technical_strategy_id ASC").includes(:technical_strategy)
      @header_title = client_name
      
    else
      #@tech_strat = @mySite.clients.first.tech_strategy_implementations.where.not(technical_strategy_id: nil).order("created_at DESC")
      #@tech_strat = @mySite.clients.first.tech_strategy_implementations.order("created_at DESC")
      #select first latest item
      @tech_strat = TechStrategyImplementation.where(client_id: TechStrategyImplementation.where.not(client_id: nil).first.nil? ? "" : TechStrategyImplementation.where.not(client_id: nil).first.client_id).order("technical_strategy_id ASC").includes(:technical_strategy)
      #must display record from first client site
      #
      @header_title = @tech_strat.present? ? @tech_strat.first.client.name : ''

    end


    pdf_blows

  end

  
  def cl_index
    @mySite = User.find(@session_user_info.id)
      
    if params[:client] and (!params[:start_date] and !params[:end_date])
      client_name = Client.find(params[:client]).name
      
      flash.now[:notice] = "Showing result for '<i><b>#{client_name}</b></i>'".html_safe
      @tech_strat = TechStrategyImplementation.search(params[:client]).where.not(technical_strategy_id: nil).order("technical_strategy_id ASC").includes(:technical_strategy)
      @header_title = client_name

    elsif params[:client] and params[:start_date] or params[:end_date]
      client_name = Client.find(params[:client]).name
      
      if params[:start_date] and params[:end_date]
        if params[:start_date].to_date > params[:end_date].to_date
            flash.now[:alert] = "End date should be later than start date!"
        else
            @start_date = params[:start_date]
            @end_date   = params[:end_date]
        end
      elsif !params[:start_date] and params[:end_date] 
            @start_date = (params[:end_date].to_date - 1.month).beginning_of_month.strftime('%Y-%m-%d')
            @end_date   = params[:end_date]  
      elsif params[:start_date] and !params[:end_date] 
            @start_date = params[:start_date]
            @end_date   = (DateTime.now.to_date).strftime('%Y-%m-%d')
      end
      
      #flash.now[:notice] = "Showing result for '<i><b>#{client_name}</b></i>' from '#{@start_date} to #{@end_date}' ".html_safe
      @tech_strat = TechStrategyImplementation.get_range(params[:client], params[:start_date], params[:end_date]).where.not(technical_strategy_id: nil).order("technical_strategy_id ASC").includes(:technical_strategy)
      @header_title = client_name
      
    else
      @tech_strat = @mySite.clients.first.tech_strategy_implementations.where.not(technical_strategy_id: nil).order("technical_strategy_id ASC").includes(:technical_strategy)
      #select first latest item
      @header_title = @tech_strat.present? ? @tech_strat.first.client.name : ''
    end

    pdf_blows

  end
  
  def new
    @tech_strat_imp = TechStrategyImplementation.new
  end
  
  def create
    @tech_strat_imp = TechStrategyImplementation.new(tech_strat_imp_params)
    
    respond_to do |format|
      if @tech_strat_imp.save
        
    		if TechStrategyImplementation.where.not(client_id: nil).count == 1  #first record
    		  format.js {render js: "window.location = '#{admin_technical_strategy_implementations_path}';"}
    		else
          format.json { head :no_content }
    		  format.js { flash.now[:notice] = "Record added!" }    		  
    		end
      else
        format.json { render json: @tech_strat_imp.errors.full_messages, status: :unprocessable_entity }
      end
    end
  end

  def edit
    @tech_strat_imp = TechStrategyImplementation.find(params[:id])
  end

  def update
    @tech_strat_imp = TechStrategyImplementation.find(params[:id])
  		respond_to do |format|
  
  		      if @tech_strat_imp.update(tech_strat_imp_params)
  		        format.json { head :no_content }
  		        format.js { flash.now[:notice] = "Updated successfully." }
  		      else
  		        format.json { render json: @tech_strat_imp.errors.full_messages, status: :unprocessable_entity }
  		      end
  		end  
  end

  
  def destroy
    tech_strat_imp = TechStrategyImplementation.find(params[:id])
    tech_strat_imp.destroy
    respond_to do |format|
      format.html { redirect_to :back, notice: 'Record deleted successfully!' }
      format.json { head :no_content }
    end
  end
  
  def import_file
 
  end
  
def process_file

      if params[:upload].nil?
        flash[:alert] = "No data imported! Please select a file."
        redirect_to :back
      else
        filename = params[:upload][:file].original_filename
        directory = "public/upload/technical_strategy_implementations"
        path = File.join(directory, filename)
        ext_name = File.extname(filename)
        File.open(path, "wb") { |f| f.write(params[:upload][:file].read) }
        
          #-----------------
          case ext_name
          when '.xls', '.xlsx'
          
            ex = Roo::Excel.new("#{Rails.root}/#{ path } ") if ext_name == '.xls'
            ex = Roo::Excelx.new("#{Rails.root}/#{ path }") if ext_name == '.xlsx'                
            ex.default_sheet = ex.sheets.first
            
            #-----------------
            #if ex.cell(1,1) == "Technical Strategies"
              upload_tsi_data = []
              upload_tsi_data_skipped = []
              tsids = TechnicalStrategy.order(id: :asc).ids
              #----------------------------
              ts_counter = -1
              ex.first_row.upto(tsids.count) do |line|
                  ts_counter += 1
                  #_col_technical_strategy   = ex.cell(line, 'A')
                  tech_strategy_id = tsids[ts_counter].present? ? tsids[ts_counter] : nil
                  _col_status  = ex.cell(line, 'A')
                  
                  #_tech_strategy = TechnicalStrategy.where('description LIKE ?', "%#{_col_technical_strategy}%").first if _col_technical_strategy.present?
                  #tech_strategy_id  = _tech_strategy.nil? ? nil : _tech_strategy.id
                  client_site       = params[:upload][:client][:id].to_i
                  #col_comment  = ex.cell(line, 'C')
                  if tech_strategy_id.present? #and _col_status.present?
                  
                    _col_status ||= 'pending' #moved inside this block to skip empty line(nil tech_startegy_id and status)
                    case _col_status.downcase.to_s
                    when "done"
                      tsi_stat = 1 #done
                      comment = nil
                    when "n/a"
                      tsi_stat = 2 #n/a
                      comment = nil
                    when "pending"
                      tsi_stat = 3 #pending
                      comment = nil
                    else
                      tsi_stat = 3 #pending
                      comment = _col_status
                    end
                    upload_tsi_data << TechStrategyImplementation.new(technical_strategy_id: tech_strategy_id, status: tsi_stat, client_id: client_site, comments: comment)
                  else
        				    upload_tsi_data_skipped << {ts_line: ts_counter, status: _col_status}
                  end
              end
              #---------------------------line end
              TechStrategyImplementation.import upload_tsi_data, batch_size: 100
              flash[:skipped_data] = upload_tsi_data_skipped
              flash[:notice] = "Import success! Records imported: #{upload_tsi_data.count}"
              redirect_to :back
            #else
            #  flash[:alert] = "Technical Strategies must be present on the first row!" 
            #  redirect_to :back
            #end
            #-----------------if end
            
          else
            flash[:alert] = "Please select excel file!"
            redirect_to :back
          end
          #-------------------switch end
      end
end

private

  def tech_strat_imp_params
      params.require(:tech_strategy_implementation).permit(:technical_strategy_id, :client_id, :status, :comments, :created_at)
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
  
  def check_tsi_table
      tsi_record = TechStrategyImplementation.where.not(client_id: nil).exists?
      
      unless tsi_record
          redirect_to empty_tsi_record_path
      end
  end

  def pdf_blows
        respond_to do |format|
          format.html do 
          end

          format.pdf do
            #@tech_strat = tech_strat
            render pdf:     "Technical-Strategy-Implementation-report", # Excluding ".pdf" extension.
            disposition:    'inline',
            layout:         'pdf',
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


  
end
