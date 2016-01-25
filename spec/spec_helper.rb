$LOAD_PATH << File.join(File.dirname(__FILE__), "../../lib")
$LOAD_PATH << File.join(File.dirname(__FILE__), "../features/feature_helper")

require "simplecov"
SimpleCov.start
require 'coveralls'
Coveralls.wear!
