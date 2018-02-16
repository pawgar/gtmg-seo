# Establish a connection between Resque and Redis
if Rails.env == "production"
  uri = URI.parse ENV["REDISCLOUD_URL"]
  Resque.redis = Redis.new host:uri.host, port:uri.port, password:uri.password
#  Resque.schedule = YAML.load_file(Rails.root.join 'config', 'static_schedule.yml')
else
#  Resque.schedule = YAML.load_file(Rails.root.join 'config', 'static_schedule.yml')
end
