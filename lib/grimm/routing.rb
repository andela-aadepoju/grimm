module Grimm
  class Router
    attr_reader :routes
    def initialize
      @routes =  Hash.new { |hash, key| hash[key] = [] }
    end

    def match(verb, url, target)
      routes[verb] << { url => target }
    end

    def get(url, args)
      match(:get, url, args)
    end

    def root(address)
      match(:get, "/", address)
    end

    def post(url, args)
      match(:post, url, args)
    end

    def put(url, args)
      match(:put, url, args)
    end

    def patch(url, args)
      match(:patch, url, args)
    end

    def delete(url, args)
      match(:delete, url, args)
    end

    def resources(args)
      get("/#{args.to_s}", "#{args.to_s}#index")
      post("/#{args.to_s}", "#{args.to_s}#create")
      put("/#{args.to_s}", "#{args.to_s}#update")
      patch("/#{args.to_s}", "#{args.to_s}#update")
      delete("/#{args.to_s}", "#{args.to_s}#destroy")
    end

    def confirm_route(verb, url)
      valid_url = check_url(verb, url)
      get_controller_for(valid_url) if valid_url
    end

    def check_url(verb, url)
      target_url = nil
      if routes[verb]
        url_verb = routes[verb]
        url_verb.each do |link|
        target_url = link[url] if link[url]
        end
      end
      target_url
    end

    def get_controller_for(url)
      link_name_array = url.split("#")
      return convert_target(link_name_array)
    end

    def convert_target(target)
      if target
        controller_name = target.first.CamelCase
        action = target.last.downcase
        controller = Object.const_get("#{controller_name}Controller")
        return controller.action(action)
      end
    end
  end
end
