require "tilt/erb"

module Grimm
  class Controller
    attr_reader :request

    def initialize(env)
      @request ||= Rack::Request.new(env)
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
      filename = File.join("app", "views", controller_name, "#{view_name}.html.erb")
      template = File.read(filename)

      vars = {}
      instance_variables.each do |var|
        key = var.to_s.gsub("@","").to_sym
        vars[key] = instance_variable_get(var)
      end
      Tilt::ERBTemplate.new(filename).render(self, locals.merge(vars))
    end

    def get_response
      @response
    end

    def controller_name
      self.class.to_s.gsub(/Controller$/, "").snake_case
    end
  end
end
