class KrmsController < ApplicationController
  layout "admin_layout"
  
  before_action :check_krm_table, only: [:index]
  before_action :verify_client_site, only: [:cl_index]
  before_action :admin_only, except: [:cl_index]
  before_action :restrict_own_site, only: [:cl_index]
 

 
  def cl_index
    
    @mySite = User.find(@session_user_info.id)
    
    if params[:client] and (!params[:start_date] and !params[:end_date])
      
      krms_all = Krm.includes(:client)
                  .search(params[:client])
                  .order('keywords ASC')
                  .group_by { |m| m.keywords }


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
 
      krms_all = Krm.includes(:client)
                  .get_range(params[:client], params[:start_date], params[:end_date])
                  .order('keywords ASC')
                  .group_by { |m| m.keywords }

      note_range = "from '#{@start_date} to #{@end_date}' "

    else
      krms_all = @mySite.clients.first.krms.includes(:client)
                  .order('keywords ASC')
                  .group_by { |m| m.keywords }  #must display record from first client site
    end 

      if krms_all.present?
        fSiteInfo = Client.find(krms_all.first[1].map(&:client_id).first) 
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
          @krms = Kaminari.paginate_array(krms_all.sort_by{|k| k[0].downcase}).page(params[:page]).per(150)  
        end
        format.pdf do
          @krms = krms_all.sort_by{|k| k[0].downcase}
          render pdf:     "KRM-report", # Excluding ".pdf" extension.
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
  
  
  def index

    if (!params[:client] && !params[:start_date] && !params[:end_date])
      krms_all = Krm.includes(:client)
                  .where(client_id: Krm.where.not(client_id: nil).first.nil? ? "" : Krm.where.not(client_id: nil).first.client_id)
                  .order('keywords ASC')
                  .group_by { |m| m.keywords }  #must display record from first client site
    else

      client_exists?

        if params[:client] and (!params[:start_date] and !params[:end_date])

          krms_all = Krm.includes(:client)
                      .search(params[:client])
                      .order('keywords ASC')
                      .group_by { |m| m.keywords }

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
     
          krms_all = Krm.includes(:client)
                      .get_range(params[:client], params[:start_date], params[:end_date])
                      .order('keywords ASC')
                      .group_by { |m| m.keywords }

          note_range = "from '#{@start_date} to #{@end_date}' "
        end
    end


      if krms_all.present?
        fSiteInfo = Client.find(krms_all.first[1].map(&:client_id).first) 
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
          @krms = Kaminari.paginate_array(krms_all.sort_by{|k| k[0].downcase}).page(params[:page]).per(150)
        end
        format.pdf do
          @krms = krms_all.sort_by{|k| k[0].downcase}
          render pdf:     "KRM-report", # Excluding ".pdf" extension.
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
    @krm = Krm.new
    @krm.client_id = params[:client]
  end
 
  def create
    @krm = Krm.new(krm_params)
    
    respond_to do |format|
      if @krm.save

        if Krm.where.not(client_id: nil).count == 1  #first record
          format.js {render js: "window.location = '#{krms_path}';"}
        else
          format.json { head :no_content }
          format.js { flash.now[:notice] = "Record added!" }          
        end
      else
        
        format.json { render json: @krm.errors.full_messages, status: :unprocessable_entity }
      end
    end
  end
  
  def edit
      @krm = Krm.find(params[:id])
  end
  
  def update
     @krm = Krm.find(params[:id])
      respond_to do |format|
  
            if @krm.update(krm_params)
              format.json { head :no_content }
              format.js { flash.now[:notice] = "Updated successfully." }
            else
              format.json { render json: @krm.errors.full_messages, status: :unprocessable_entity }
            end
      end    
  end
  
  def no_record
    krm_record = Krm.where.not(client_id: nil).exists?
    
    if krm_record
      redirect_to krms_path
    else
      flash.now[:alert] = "Record empty!"
      @krm = Krm.new      
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

  def destroy
    
    @krm = Krm.find(params[:id])
    @krm.destroy
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
          directory = "public/upload/krms"
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
              krm_date           = params[:upload][:date]              
              #-----------------
                upload_krm_data = []
                upload_krm_data_skipped = []
                #----------------------------
                krm_counter = 1
                2.upto(ex.last_row) do |line|
                    krm_counter += 1
                    _col_krm_keywords   = ex.formatted_value(line, 'A')
                    _col_krm_keyword = _col_krm_keywords.present? ? _col_krm_keywords.strip.downcase : nil
                    #_col_krm_value  = ex.formatted_value(line, 'B')  #get value as displayed in excel
                    _col_krm_value_format  = ex.excelx_type(line, 'B')

                    _col_krm_value_format ||= [:numeric_or_formula, 'Unknown']

                      if _col_krm_value_format[1] == 'General' 
                        _col_krm_value  = ex.cell(line, 'B')  #get unformatted/numeric value
                      else
                        _col_krm_value  = ex.formatted_value(line, 'B')  #get formatted value as displayed in excel
                      end

                    _col_krm_value ||= 0

                    if Krm.find_by("lower(keywords) = ? AND client_id = ? AND date = ?", _col_krm_keyword, client_site, (Time.strptime(krm_date, "%b %Y")).strftime('%F %T') )
                      #check existence ...scope => [:keywords, :client_id, :date]
                      upload_krm_data_skipped << {l: krm_counter, f: "X0"} #if true...then skip data

                    else  #if false...then proceed for import

                      if _col_krm_keyword.present? and _col_krm_value.present?
                        upload_krm_data << Krm.new(keywords: _col_krm_keyword, page_rank: _col_krm_value, client_id: client_site, date: krm_date)

                      else #skip for nil krm_objective_id and krm_value
                        upload_krm_data_skipped << {l: krm_counter, f: "X1"} #_col_krm_value
                      end

                    end
                    
                end
                #---------------------------line end
                Krm.import upload_krm_data, batch_size: 100#, validate: false
                flash[:skipped_data] = upload_krm_data_skipped
                flash[:notice] = "Import success! Records imported: #{upload_krm_data.count}" if upload_krm_data.count != 0
                flash[:alert] = "Import failed! Records imported: #{upload_krm_data.count}" if upload_krm_data.count == 0
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
  
  def krm_params
    params.require(:krm).permit(:client_id, :keywords, :date, :page_rank)
  end
  
  def check_krm_table
      krm_record = Krm.where.not(client_id: nil).exists?
      
      unless krm_record
          redirect_to empty_krm_record_path
      end
  end

  def restrict_own_site
    if params[:client]
        site = params[:client].to_i
        
        find_user_site = ClientUser.find_by(user_id: @session_user_info.id, client_id: site)
        unless find_user_site
            flash.now[:alert] = "Site not found!"
            redirect_to keywords_ranking_monitoring_path
        end
    end
  end

  def client_exists?
    params[:client] ||= 0
    check = Client.where(id: params[:client]).blank?
    if check
      flash[:alert] = "Site not found!"
       redirect_to krms_path #and return
    end
  end
  
end
