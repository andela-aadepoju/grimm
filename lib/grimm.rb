require "grimm/version"
require "grimm/controller.rb"
require "grimm/utilities.rb"
require "grimm/dependencies.rb"
require "grimm/routing.rb"
require "pry"
require "grimm/orm/grimm_record.rb"

module Grimm
  class Application
    attr_reader :request
    def call(env)
      @request = Rack::Request.new(env)
      if request.path_info == "/favicon.ico"
        return [404, {}, []]
      end
      page = get_rack_app(request)
      if page.nil?
        return [404, {}, ["#{request.request_method.downcase} #{request.path}
          was not defined in the route. Check /config/routes.rb for defined
          routes"]]
      else
        page
      end
    end

    def route
      @router ||= Grimm::Router.new
    end

    def get_rack_app(request)
      @router.check_url(request)
    end
  end
end
