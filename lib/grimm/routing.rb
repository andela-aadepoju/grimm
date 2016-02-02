module Grimm
  class Router
    attr_reader :routes
    def initialize
      @routes = Hash.new { |hash, key| hash[key] = [] }
    end

    def self.match_verbs(*verbs)
      verbs.each do |verb|
        define_method(verb) do |url, options = {}|
          url_parts = url.split("/")
          url_parts.select! { |part| !part.empty? }
          placeholder = []
          regexp_parts = url_parts.map do |part|
            check_part(placeholder, part)
          end
          save_routes(regexp_parts, verb, placeholder, options)
        end
      end
    end

    def check_part(placeholder, part)
      if part[0] == ":"
        placeholder << part[1..-1]
        "([A-Za-z0-9_]+)"
      else
        part
      end
    end

    def save_routes(regexp_parts, verb, placeholder, options)
      regexp = regexp_parts.join("/")
      routes[verb] << [Regexp.new("^/#{regexp}$"),
                       parse_to(options[:to]), placeholder]
    end

    match_verbs :get, :post, :put, :patch, :delete

    def draw(&block)
      instance_eval(&block)
    end

    def root(address)
      get("/", to: address)
    end

    def resources(args)
      args = args.to_s
      get("/#{args}", to: "#{args}#index")
      get("/#{args}/new", to: "#{args}#new")
      get("/#{args}/:id", to: "#{args}#show")
      get("/#{args}/edit/:id", to: "#{args}#edit")
      delete("/#{args}/:id", to: "#{args}#destroy")
      post("/#{args}/", to: "#{args}#create")
      put("/#{args}/:id", to: "#{args}#update")
    end

    def check_url(request)
      url = request.path_info
      verb = request.request_method.downcase.to_sym
      route_match = routes[verb].detect do |route|
        route.first.match(url)
      end
      find_match(route_match, url, request)
    end

    def find_match(route_match, url, request)
      if route_match
        placeholder = {}
        match = route_match.first.match(url)
        held_value = route_match[2]
        held_value.each_with_index do |value, index|
          placeholder[value] = match.captures[index]
        end
        request.params.merge!(placeholder)
        route_match << placeholder
        return convert_target(request, route_match[1])
      end
    end

    def convert_target(request, route)
      controller_name = route[:controller].camelcase
      controller = Object.const_get("#{controller_name}Controller")
      controller.action(request, route[:target])
    end

    private

    def parse_to(option)
      controller, target = option.split("#")
      { controller: controller.camelcase, target: target }
    end
  end
end
