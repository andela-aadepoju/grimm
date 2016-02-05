require "thor"
module Grimm
  class Server < Thor
    desc "server", "This starts the app server"
    def server
      start_server
    end

    private

    def start_server
      exec "bundle exec rackup"
    end
  end
end

Grimm::Server.start(ARGV)
