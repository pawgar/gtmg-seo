class PagesController < ApplicationController
  
  before_action :restrict_own_site, only: [:dashboard]
  before_action :select_default, only: [:dashboard]



  def dashboard
    case @session_user_info.role
    when "Client"
      client_dash
    when "Administrator"
      admin_dash
    end

    ga_report_method if @client_info.present?

    @client = Client.new
    @mySite = User.find(@session_user_info.id)

    render layout: "admin_layout"
  end




private

  def client_dash 

    if params[:client].nil?
      @client_info = @session_user_info.clients.check_valid_analytic_id.first
    else

        client_info = Client.check_valid_analytic_id.where(id: @validate.client_id).first
        if client_info.present?
            @client_info = client_info
        end

    end

    #render layout: "admin_layout"
  end

  def admin_dash
    if params[:client].nil?
      @client_info  = Client.check_valid_analytic_id.first
    else

      if @get_valid_site.present?
          @client_info = @get_valid_site
      end
    end
  end


  def ga_report_method
    require 'googleauth'
    require 'google/apis/analytics_v3'

      analytics = Google::Apis::AnalyticsV3::AnalyticsService.new

      analytics.authorization = Google::Auth::ServiceAccountCredentials.make_creds(
        json_key_io: File.open("#{Rails.root}/config/GTMGseo-bcbbbc941baf.json"),
        scope: 'https://www.googleapis.com/auth/analytics.readonly'
        )


      @access_token = analytics.authorization.fetch_access_token!({})["access_token"]   #retieve only token
      analytics.authorization.fetch_access_token!

      # make queries
      @ids = "ga:#{@client_info.ga_profile_id}" # your GA profile id, looks like 'ga:12345'
      today_in_utc = DateTime.now.utc.in_time_zone('Mountain Time (US & Canada)')
      start_date =  (today_in_utc - 30.days).strftime('%Y-%m-%d') #'29daysAgo'#Date.new(2017,11,6).to_s
      end_date = (today_in_utc - 1.days).strftime('%Y-%m-%d') #'today' 
      #dimensions = 'ga:pagePath'
      dimensions = 'ga:keyword'
      metrics = 'ga:sessions' #'ga:pageviews'
      #filters = 'ga:pagePath==/url/to/user'     59days   30days      .... 57days  28days
      filters = 'ga:country!=India,ga:country!=Philippines,ga:country!=Russia,ga:country!=China'
      sort = '-ga:sessions'

      result = analytics.get_ga_data(@ids, start_date, end_date, metrics, dimensions: dimensions, sort: sort)
      @traffic_source = analytics.get_ga_data(@ids, start_date, end_date, metrics, dimensions: 'ga:country,ga:source', sort: '-ga:sessions', filters: filters, max_results: 10)
      @page_views = analytics.get_ga_data(@ids, start_date, end_date, 'ga:pageviews', dimensions: 'ga:pageTitle', sort: '-ga:pageviews', max_results: 10)
      @realtime = analytics.get_realtime_data(@ids, 'rt:activeUsers', dimensions: 'rt:medium,rt:source,rt:country')

      @data_last_30days_total = analytics.get_ga_data(@ids, (today_in_utc - 60.days).strftime('%Y-%m-%d'), (today_in_utc - 31.days).strftime('%Y-%m-%d'), 'ga:users, ga:sessions, ga:bounceRate, ga:avgSessionDuration')
      @data_30days_total = analytics.get_ga_data(@ids, start_date, end_date, 'ga:users, ga:sessions, ga:bounceRate, ga:avgSessionDuration')

#=======users
      change_users     = (@data_30days_total.rows.first[0].to_i - @data_last_30days_total.rows.first[0].to_i)
      @pc_result_users = (change_users.to_f / (@data_last_30days_total.rows.first[0].to_i)) * 100

#=======sessions
      change_sessions     = (@data_30days_total.rows.first[1].to_i - @data_last_30days_total.rows.first[1].to_i)
      @pc_result_sessions = (change_sessions.to_f / (@data_last_30days_total.rows.first[1].to_i)) * 100

#=======bounceRate
      change_bounceRate   = (@data_30days_total.rows.first[2].to_f - @data_last_30days_total.rows.first[2].to_f)
      @pc_result_bounceRate = (change_bounceRate.to_f / (@data_last_30days_total.rows.first[2].to_f)) * 100

#=======avgSessionDuration
      change_avgSessionDuration     = (@data_30days_total.rows.first[3].to_f - @data_last_30days_total.rows.first[3].to_f)
      @pc_result_avgSessionDuration = (change_avgSessionDuration.to_f / (@data_last_30days_total.rows.first[3].to_f)) * 100


      @data_30days = analytics.get_ga_data(@ids, start_date, end_date, 'ga:users, ga:sessions, ga:bounceRate, ga:avgSessionDuration', dimensions: 'ga:date')
      @data_last_30days = analytics.get_ga_data(@ids, (today_in_utc - 58.days).strftime('%Y-%m-%d'), (today_in_utc - 29.days).strftime('%Y-%m-%d'), 'ga:users, ga:sessions, ga:bounceRate, ga:avgSessionDuration', dimensions: 'ga:date')


  end

  def select_default
    if @session_user_info.Administrator?
      if params[:client]
        @get_valid_site = Client.check_valid_analytic_id.where(id: params[:client]).first

        unless @get_valid_site
            flash[:alert] = "Site not found!"
            redirect_to dashboard_path
        end
      end
    end

  end

  def restrict_own_site #client only
    if @session_user_info.Client?
       uid = @session_user_info.id
      if params[:client]
          cid = params[:client]
          @validate = ClientUser.find_by(user_id: uid, client_id: cid)
          unless @validate
            flash[:alert] = "Site not found!"
            redirect_to dashboard_path
          end
      end
    end
  end


end
