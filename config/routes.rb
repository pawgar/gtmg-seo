Rails.application.routes.draw do


    get "monthly-report" =>  'monthly_reports#cl_index'
    
  controller :monthly_reports, path: "monthly-reports" do
    get "import-report" =>  'monthly_reports#import_report', as: "import-report"
    get "download-pdf/:id" =>  'monthly_reports#pdf', as: "download_pdf"
    get "view-pdf/:id" =>  'monthly_reports#view_pdf', as: "view_pdf"
  end

  resources :monthly_reports, path: "monthly-reports"

  get 'monthly_reports/upload_report'

    match "/404", :to => "errors#not_found", :via => :all
    match "/500", :to => "errors#internal_server_error", :via => :all

    get 'kpis/index'
    get 'pages/dashboard'
    get '/dashboard' => 'pages#dashboard'
    

    post 'clients/assign_user'
    delete '/delete_assigned_user/' => 'clients#delete_assigned_user'
  
  
    root 'pages#dashboard'
   
   resources :users do
       member do
           get '/change-avatar' => 'users#change_avatar'
           patch :update_avatar
        end
    end
   
   controller :users do 
            get '/register' => 'users#client_registration'
            post '/create-client' => 'users#create_client'
   end    
    
   resources :sessions
   
    controller :sessions do
       get "account-login" => :index
       post 'user_login' => :user_login
       delete '/user-logout' => :user_logout
    end
    
    
    controller :password_resets do
            get "/reset-password" => 'password_resets#new'
    end
    resources :password_resets
    
    
    resources :clients do
        member do
          get 'add_notes'
          patch 'create_notes'
        end
    end
    
    controller :clients do
         get 'new-site' => 'clients#new_site'
         post 'create_cl' => 'clients#create_cl'
         get 'edit-site/:id' => 'clients#edit_cl', as: "edit-site"
         patch 'update-site/:id' => 'clients#update_cl', as: "update-site"
         delete 'delete-site/:id' => 'clients#destroy_cl', as: "destroy-site"
         get 'show-site-note/:id' => 'clients#show_note_cl', as: "show-site-note"
    end
    
    resources :strategies
    
    controller :strategies do
        get '/import-strategy-form' => 'strategies#import_strategy_form'
        post '/import-strategy-file' => 'strategies#import_strategy_file'
    end
    
    resources :efforts do
       resources :qa_comments, shallow: true     # efforts/:id/qa_comments/index   only this [:index, :new, create]
       
       controller :qa_comments do 
            post '/save-incoming' => 'qa_comments#save_incoming'
       end
    end
        controller :efforts do 
            get '/upload-effort-file' => 'efforts#upload_effort'
            post '/process-uploaded-effort-file' => 'efforts#process_uploaded_effort'
            get '/uploaded-effort-file' => 'efforts#uploaded_effort' 
            get '/efforts-report' => 'efforts#cl_index'
            get '/empty-effort-record' => 'efforts#no_record'
        end
    resources :krms 
        controller :krms do
            get '/empty-krm-record' => 'krms#no_record'
            get '/keywords-ranking-monitoring' => 'krms#cl_index'
            get '/admin/krm/import-file' => 'krms#import_file'
            post '/import-krm-file' => 'krms#process_file'
            delete 'removeKrm/:id' => 'krms#destroy', as: 'removeKrm'
        end
    resources :kpi_objectives, path: "kpi-objectives" do
            get :autocomplete_kpi_objective_title, :on => :collection
    end
    resources :kpis
        controller :kpis do
            get '/empty-kpi-record' => 'kpis#no_record'
            get '/key-performance-index' => 'kpis#cl_index'
            get '/admin/kpi/import-file' => 'kpis#import_file'
            post '/import-kpi-file' => 'kpis#process_file'
            delete 'removeKpi/:id' => 'kpis#destroy', as: 'removeKpi'
        end
        
    resources :uploads
    
    controller :client_users do 
        patch 'add-ownership/:id' => 'client_users#add_as_owner', as: 'add-ownership'
        patch 'take-ownership/:id' => 'client_users#remove_as_owner', as: 'take-ownership'
    end

    resources :tech_strategy_implementations
        controller :tech_strategy_implementations do
            get '/admin/technical-strategy-implementations' => 'tech_strategy_implementations#index'
            get '/admin/technical-strategy-implementations/import-file' => 'tech_strategy_implementations#import_file'
            get '/technical-strategy-implementations' => 'tech_strategy_implementations#cl_index'
            post '/import-technical-strategy-implementation-file' => 'tech_strategy_implementations#process_file'
            get '/empty-tsi-record' => 'tech_strategy_implementations#no_record'
        end

        
    resources :technical_strategies, path: 'technical-strategies'
    resources :offpage_categories, path: 'off-page-categories'
    resources :strategy_offpage_categories, path: 'strategy-offpage-categories'
    delete 'unassignCategory/:id' => 'strategy_offpage_categories#destroy', as: 'unassignCategory'

    #---------------------------------------------
  require 'resque/server' 
  #require 'resque/scheduler/server'       #when using resque-scheduler 
  mount Resque::Server.new, at: "/seo-gtmg-resque"
    
  get '/auth/:provider/callback' => 'social_auth#create'
  get '/auth/failure', to: redirect('/account-login')

end
