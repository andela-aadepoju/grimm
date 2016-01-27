# \ -p 4500
$LOAD_PATH.unshift __dir__
require "./config/application.rb"
use Rack::MethodOverride
GrimmApplication = GrimmTodo::Application.new
require "./config/routes.rb"
