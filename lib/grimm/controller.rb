require "tilt/erb"

module Grimm
  class Controller
    def render(view_name, locals = {})
      filename = File.join("app", "views", controller_name, "#{view_name}.html.erb")
      template = File.read(filename)
      Tilt::ERBTemplate.new(filename).render(self, locals)
    end

    def controller_name
      self.class.to_s.gsub(/Controller$/, "").snake_case
    end
  end
end
