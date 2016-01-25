# \ -p 4500

require "./config/application.rb"
use Rack::Reloader, 0
GrimmApplication = GrimmTodo::Application.new
require "./config/routes.rb"
run GrimmApplication
