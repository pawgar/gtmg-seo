require "resque/tasks"
#require 'resque/scheduler/tasks'

task "resque:setup" => :environment do
  require 'resque'
#  require 'resque-scheduler'
    ### //  Resque.schedule = YAML.load_file(Rails.root.join 'config', 'static_schedule.yml')
    #moved to config/initializers/resque.rb inorder to display scheduled jobs on the schedule tab.  //
end
