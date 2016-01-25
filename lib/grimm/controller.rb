require "tilt/erb"

module Grimm
  class BaseController
    attr_reader :request, :response

    def initialize(request)
      @request = request
    end

    def params
      request.params
    end

    def render(*args)
      response(render_template(*args))
    end

    def response(body, status = 200, header = {})
      @response = Rack::Response.new(body, status, header)
    end

    def render_template(view_name, locals = {})
      template = Tilt::ERBTemplate.new(File.join($:.first, "app", "views",
                                                 "layouts",
                                                 "application.html.erb"))
      title = view_name.to_s.tr("_", " ").capitalize
      view = "#{view_name}.html.erb"
      view_template = Tilt::ERBTemplate.new(File.join($:.first, "app", "views",
                                                      controller_name, view))
      template.render(self, title: title) do
        view_template.render(self, locals.merge!(get_vars))
      end
    end

    def get_vars
      vars = {}
      instance_variables.each do |var|
        key = var.to_s.delete("@").to_sym
        vars[key] = instance_variable_get(var)
      end
      vars
    end

    def get_response
      @response
    end

    def controller_name
      self.class.to_s.gsub(/Controller$/, "").snake_case
    end

    def redirect_to(url)
      @response = Rack::Response.new({}, 302, "location" => url)
    end

    def dispatch(action)
      send(action)
      if get_response
        get_response
      else
        render(action)
        get_response
      end
    end

    def self.action(request, action_name)
      new(request).dispatch(action_name)
    end
  end
end
