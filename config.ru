#s file is used by Rack-based servers to start the application.
#require ::File.expand_path('../config/environment', __FILE__)
#run Usercrm::Application

#require ::File.expand_path('../config/environment',  __FILE__)
require 'logger'
#$LOAD_PATH.unshift File.dirname(__FILE__) + '/../../lib'
#require 'app'
require 'resque/server'

use Rack::ShowExceptions

# Set the AUTH env variable to your basic auth password to protect Resque.
AUTH_PASSWORD = ENV['AUTH']
if AUTH_PASSWORD
  Resque::Server.use Rack::Auth::Basic do |username, password|
    password == AUTH_PASSWORD
  end
end
puts 'about to start urlmap'
#run Rack::URLMap.new \
#  "/resque" => Resque::Server.new
map '/resque' do
   run Resque::Server.new
end
