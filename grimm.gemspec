# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "grimm/version"

Gem::Specification.new do |spec|
  spec.name          = "grimm"
  spec.version       = Grimm::VERSION
  spec.authors       = ["mradeybee"]
  spec.email         = ["mradeybee@gmail.com"]

  spec.summary       = "A ruby framework"
  spec.description   = "This is a mini framework built with ruby."
  spec.homepage      = "https://github.com/andela-aadepoju/grimm"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org by setting "allowed_push_host", or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "https://rubygems.org"
  else
    raise "RubyGems 2.0 or newer is required to
    protect against public gem pushes."
  end

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"``
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_runtime_dependency "rack"
  spec.add_runtime_dependency "tilt"
  spec.add_runtime_dependency "pry"
  spec.add_runtime_dependency "puma"
  spec.add_runtime_dependency "sqlite3"
end
