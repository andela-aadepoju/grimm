require "grimm/version"
require "grimm/controller.rb"
require "grimm/utilities.rb"
require "grimm/dependencies.rb"

module Grimm
  class Application
    def call(env)
      if env["PATH_INFO"]== "/"
        return [302, {"Location" => "/pages/index"}, []]
      end
      if env["PATH_INFO"]== "/favicon.ico"
        return [400, {}, []]
      end

      controller_class, action = get_controller_and_action(env)
      response = controller_class.new
      controller = response.send(action)
      [200, { "Content-Type" => "text/html" }, [controller]]
    end

    def get_controller_and_action(env)
      _, controller_name, action = env["PATH_INFO"].split("/")
      controller_name = controller_name.CamelCase + "Controller"
      [Object.const_get(controller_name), action]
    end
  end
end
