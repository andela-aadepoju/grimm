require "grimm/version"
require "grimm/controller.rb"
require "grimm/utilities.rb"
require "grimm/dependencies.rb"
require "grimm/routing.rb"
require "pry"

module Grimm
  class Application
    attr_reader :request
    def call(env)
      @request = Rack::Request.new(env)
      if request.path_info == "/favicon.ico"
        return [500,{}, []]
      end
      return [404, {}, ["This route is not defined"]] unless get_rack_app(env)
    end

    def route(&block)
      @router ||= Grimm::Router.new
      @router.instance_eval(&block)
    end

    def get_rack_app(env)
      path = request.path_info
      method = request.request_method.downcase.to_sym
      @router.confirm_route(method, path)
    end
  end
end
