require "spec_helper"
require "capybara/rspec"
$LOAD_PATH << File.join(File.dirname(__FILE__), "grimm_app")
require "test_helper"

RSpec.configure do |config|
  config.before(:each) do
    Capybara.app = APP
    List.delete_all
    @list = List.new
    @list.title = "Fists Todo"
    @list.body = "First Todo Body"
    @list.done = "false"
    @list.created_at = Time.now.to_s
    @list.save
  end
end
