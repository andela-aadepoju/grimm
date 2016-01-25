$LOAD_PATH.unshift __dir__
require "config/application.rb"
GrimmApplication = GrimmTodo::Application.new
require "config/routes.rb"
