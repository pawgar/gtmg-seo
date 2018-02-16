class KpisController < ApplicationController
  
  layout "admin_layout"
  before_action :authorize, except: [:autocomplete_kpi_title]
  before_action :check_kpi_table, only: [:index]
  before_action :restrict_own_site, only: [:cl_index]
  before_action :admin_only, except: [:cl_index]
  

#client 
  def index


    if (!params[:client] && !params[:start_date] && !params[:end_date])

      kpis_all = Kpi.includes(:client, :kpi_objective)
                  .where(client_id: Kpi.where.not(client_id: nil).first.nil? ? "" : Kpi.where.not(client_id: nil).first.client_id)
                  .group_by { |m| m.kpi_objective.title }

    else

      client_exists?

        if params[:client] and (!params[:start_date] and !params[:end_date])

            kpis_all = Kpi.includes(:client, :kpi_objective)
                  .search(params[:client])
                  .group_by { |m| m.kpi_objective.title }

        elsif params[:client] and params[:start_date] or params[:end_date]

          if params[:start_date] and params[:end_date]
                @start_date = params[:start_date]
                @end_date   = params[:end_date]
          elsif !params[:start_date] and params[:end_date] 
                @start_date = (params[:end_date].to_date - 6.months).strftime('%b %Y')
                @end_date   = params[:end_date]  
          elsif params[:start_date] and !params[:end_date] 
                @start_date = params[:start_date]
                @end_date   = (DateTime.now.to_date).strftime('%b %Y')
          end
 
            kpis_all = Kpi.includes(:client, :kpi_objective)
                          .get_range(params[:client], params[:start_date], params[:end_date])
                          .group_by { |m| m.kpi_objective.title }

            note_range = "from '#{@start_date} to #{@end_date}' "
        end
    end

      if kpis_all.present?
        fSiteInfo = Client.find(kpis_all.first[1].map(&:client_id).first) 
        @fSiteInfo_name = fSiteInfo.name
        @fSiteInfo_id = fSiteInfo.id
        flash.now[:notice] = "Showing result for '<i><b>#{@fSiteInfo_name}</b></i>'".html_safe
      else

        fSiteInfo = Client.where(params[:client]).first
        @fSiteInfo_name = fSiteInfo.name
        @fSiteInfo_id = fSiteInfo.id
        flash.now[:alert] = "No entries found!"
      end 

      respond_to do |format|
        format.html do 
          @kpis = Kaminari.paginate_array(kpis_all.sort_by{|k| k[0].downcase}).page(params[:page]).per(30)
        end
        format.pdf do
          @kpis = kpis_all.sort_by{|k| k[0].downcase}
          render pdf:     "KPI-report", # Excluding ".pdf" extension.
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

  def cl_index


    @mySite = User.find(@session_user_info.id)
    
    if params[:client] and (!params[:start_date] and !params[:end_date])
      
      kpis_all = Kpi.includes(:kpi_objective, :client)
                .search(params[:client])
                .group_by { |m| m.kpi_objective.title }


    elsif params[:client] and params[:start_date] or params[:end_date]

      if params[:start_date] and params[:end_date]
            @start_date = params[:start_date]
            @end_date   = params[:end_date]
      elsif !params[:start_date] and params[:end_date] 
            @start_date = (params[:end_date].to_date - 6.months).strftime('%b %Y')
            @end_date   = params[:end_date]  
      elsif params[:start_date] and !params[:end_date] 
            @start_date = params[:start_date]
            @end_date   = (DateTime.now.to_date).strftime('%b %Y')
      end
 
      kpis_all = Kpi.includes(:kpi_objective)
                  .get_range(params[:client], params[:start_date], params[:end_date])
                  .group_by { |m| m.kpi_objective.title }

      note_range = "from '#{@start_date} to #{@end_date}' "

    else
      kpis_all = @mySite.clients.first.kpis
                  .includes(:kpi_objective)
                  .group_by { |m| m.kpi_objective.title } 
    end 

      if kpis_all.present?
        fSiteInfo = Client.find(kpis_all.first[1].map(&:client_id).first) 
        @fSiteInfo_name = fSiteInfo.name
        @fSiteInfo_id = fSiteInfo.id
        flash.now[:notice] = "Showing result for '<i><b>#{@fSiteInfo_name}</b></i>' #{note_range}".html_safe
      else
        fSiteInfo = @mySite.clients.first
        @fSiteInfo_name = fSiteInfo.name
        @fSiteInfo_id = fSiteInfo.id
        flash.now[:alert] = "No entries found!"
      end 

      respond_to do |format|
        format.html do 
          @kpis = Kaminari.paginate_array(kpis_all.sort_by{|k| k[0].downcase}).page(params[:page]).per(30) 
        end
        format.pdf do
          @kpis = kpis_all.sort_by{|k| k[0].downcase}
          render pdf:     "KPI-report", # Excluding ".pdf" extension.
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
  

  def new
    @kpi = Kpi.new
    @kpi.client_id = params[:client]
  end
  
  def create
    @kpi = Kpi.new(kpi_params)
    
     get_kpi_objective_id = KpiObjective.find_by(title: params[:kpi][:kpi_objective_id])
     @kpi.kpi_objective_id  = (get_kpi_objective_id.present? ? get_kpi_objective_id.id : nil)
     
    respond_to do |format|
      if @kpi.save

        if Kpi.where.not(client_id: nil).count == 1
          format.js {render js: "window.location = '#{kpis_path}';"}
        else
          format.json { head :no_content }
          format.js { flash.now[:notice] = "Record added!" }          
        end
      else
        
        format.json { render json: @kpi.errors.full_messages, status: :unprocessable_entity }
      end
    end
  end

  def edit
      @kpi = Kpi.find(params[:id])
  end
  
  def update
     @kpi = Kpi.find(params[:id])
     get_kpi_objective_id = KpiObjective.find_by(title: params[:kpi][:kpi_objective_id])
     
     @kpi.kpi_objective_id  = (get_kpi_objective_id.present? ? get_kpi_objective_id.id : nil)
     @kpi.client_id = params[:kpi][:client_id]
     @kpi.date  = params[:kpi][:date]
     @kpi.kpi_value = params[:kpi][:kpi_value]
     
      respond_to do |format|

          if @kpi.changed?

            if @kpi.save
              format.json { head :no_content }
              format.js { flash.now[:notice] = "Updated successfully." }
            else
              format.json { render json: @kpi.errors.full_messages, status: :unprocessable_entity }
            end

          else
            @kpi.errors.add(:base, "No changes made!")
            format.json { render json: @kpi.errors.full_messages, status: :unprocessable_entity }
          end
      end  
  end



  def destroy
    
    @kpi = Kpi.find(params[:id])
    @kpi.destroy
    respond_to do |format|

      format.json { head :no_content }
      format.js { flash.now[:notice] = "Record has been successfully removed!" }
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
          directory = "public/upload/kpis"
          path = File.join(directory, filename)
          ext_name = File.extname(filename)
          File.open(path, "wb") { |f| f.write(params[:upload][:file].read) }
          
            #-----------------
            case ext_name
            when '.xls', '.xlsx'
            
              ex = Roo::Excel.new("#{Rails.root}/#{ path } ") if ext_name == '.xls'
              ex = Roo::Excelx.new("#{Rails.root}/#{ path }") if ext_name == '.xlsx'                
              ex.default_sheet   = ex.sheets.first
              client_site        = params[:upload][:client][:id].to_i
              kpi_date           = params[:upload][:date]              
              #-----------------
                upload_kpi_data = []
                upload_kpi_data_skipped = []
                #----------------------------
                kpi_counter = 1
                2.upto(ex.last_row) do |line|
                    kpi_counter += 1
                    _col_kpi_objectives   = ex.formatted_value(line, 'A')
                    _col_kpi_objective = _col_kpi_objectives.present? ? _col_kpi_objectives.strip : nil
                    #_col_kpi_value  = ex.formatted_value(line, 'B')  #get value as displayed in excel
                    _col_kpi_value_format  = ex.excelx_type(line, 'B')

                    _col_kpi_value_format ||= [:numeric_or_formula, 'Unknown']

                      if _col_kpi_value_format[1] == 'General' 
                        _col_kpi_value  = ex.cell(line, 'B')  #get unformatted/numeric value
                      else
                        _col_kpi_value  = ex.formatted_value(line, 'B')  #get formatted value as displayed in excel
                      end
                    
                    _kpi_objective     = KpiObjective.where('title LIKE ?', "#{_col_kpi_objective}").first if _col_kpi_objective.present?
                    kpi_objective_id  = _kpi_objective.present? ? _kpi_objective.id : nil
                    
                    if Kpi.find_by(kpi_objective_id: kpi_objective_id, client_id: client_site, date: (Time.strptime(kpi_date, "%b %Y")).strftime('%F %T') )
                      #check existence ...scope => [:kpi_objective, :date]
                      upload_kpi_data_skipped << {ts_line: kpi_counter, value: _col_kpi_objective, failure: "FC-X000"} #if true...then skip data

                    else  #if false...then proceed for import

                      if kpi_objective_id.present? and _col_kpi_value.present?
                        upload_kpi_data << Kpi.new(kpi_objective_id: kpi_objective_id, kpi_value: _col_kpi_value, client_id: client_site, date: kpi_date)

                      else #skip for nil kpi_objective_id and kpi_value
                        upload_kpi_data_skipped << {ts_line: kpi_counter, value: _col_kpi_objective, failure: "FC-X001"} #_col_kpi_value
                      end

                    end
                    
                end
                #---------------------------line end
                Kpi.import upload_kpi_data, batch_size: 100#, validate: false
                flash[:skipped_data] = upload_kpi_data_skipped
                flash[:notice] = "Import success! Records imported: #{upload_kpi_data.count}" if upload_kpi_data.count != 0
                flash[:alert] = "Import failed! Records imported: #{upload_kpi_data.count}" if upload_kpi_data.count == 0
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

  def kpi_params
      params.require(:kpi).permit(:client_id, :kpi_value, :kpi_objective_id, :date)
  end

  def check_kpi_table
      kpi_record = Kpi.where.not(client_id: nil).exists?
      
      unless kpi_record
          redirect_to empty_kpi_record_path
      end
  end

  def restrict_own_site
    if params[:client]
        site = params[:client].to_i
        
        find_user_site = ClientUser.find_by(user_id: @session_user_info.id, client_id: site)
        unless find_user_site
            flash[:alert] = "Site not found!"
            #raise ActionController::RoutingError.new('Not Found')
            redirect_to key_performance_index_path and return
        end
    end
  end

  def client_exists?
    params[:client] ||= 0 
    check = Client.where(id: params[:client]).blank?
    if check
      flash[:alert] = "Site not found!"
       redirect_to kpis_path and return
    end
  end

end
