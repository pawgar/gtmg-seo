Rails.application.config.middleware.use OmniAuth::Builder do
  #provider :facebook, ENV['FB_API_KEY'], ENV['FB_API_SECRET'], {
  provider :facebook, ENV['FB_API_KEY'], ENV['FB_API_SECRET'],{
  		   scope: "public_profile,email", info_fields: "email,name, first_name, last_name", :display => 'popup'
  }
 

 
if Rails.env == "production"
    redirect_uri = 'http://seo.globaltechmarketinggroup.com/auth/google/callback' || 'https://seo.globaltechmarketinggroup.com/auth/google/callback'
   # || 'https://gtmg-seo.herokuapp.com/auth/google/callback' || 'http://gtmg-seo.herokuapp.com/auth/google/callback' || 
else
    #redirect_uri = 'https://gtmg-seo-valcaro87.c9users.io/auth/google/callback'  #c9 IDE
    redirect_uri = 'http://localhost:3000/auth/google/callback'    #localhost
end
    provider :google_oauth2, ENV["GOOGLE_CLIENT_ID"], ENV["GOOGLE_SECRET"], {
    #client_options: {ssl: {ca_file: Rails.root.join("cacert.pem").to_s}},
        name: "google", scope: "email, profile", image_aspect_ratio: 'square', image_size: 48, access_type: 'online', skip_jwt: true,
              setup: (lambda do |env|
              request = Rack::Request.new(env)
              env['omniauth.strategy'].options['token_params'] = {:redirect_uri => redirect_uri} #{:redirect_uri => 'http://localhost:3000/auth/google/callback'}
            end) 
  }


  		   
  provider :linkedin, ENV['LINKEDIN_KEY'], ENV['LINKEDIN_SECRET'],{
           :scope => 'r_basicprofile r_emailaddress'
  } 			
end