# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'vapebot/version'

Gem::Specification.new do |spec|
  spec.name          = "vapebot"
  spec.version       = Vapebot::VERSION
  spec.authors       = ["jakenotjacob"]
  spec.email         = ["jake.campbell91@gmail.com"]
  spec.description   = "vapebot is an IRC bot to assist in chat on freenode's ##vaperhangout channel."
  spec.homepage      = "reddit.com/r/vapeheads"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  ##if spec.respond_to?(:metadata)
  ##  spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  ##else
  ##  raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  ##end

  spec.files = %w[vapebot.gemspec] + Dir['*.md', 'bin/*', 'lib/**/*.rb']
  spec.executables   = %w[vapebot]
  spec.require_paths = %w[lib]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
end
