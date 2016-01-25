$:.unshift File.dirname(__FILE__)
require "config/application.rb"
GrimmApplication = GrimmTodo::Application.new
require "config/routes.rb"

APP = Rack::Builder.new do
  use Rack::MethodOverride
  run GrimmApplication
end
