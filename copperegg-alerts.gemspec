# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'copperegg/version'

Gem::Specification.new do |spec|
  spec.name          = "copperegg-alerts"
  spec.version       = Copperegg::VERSION
  spec.authors       = ['Cargo Media', 'ppp0']
  spec.email         = 'hello@cargomedia.ch'
  spec.summary       = 'A very minimalistic Copperegg API client for managing alerts'
  spec.description   = 'Set and remove alert silencing schedules aka maintenance windows'
  spec.homepage      = 'www.cargomedia.ch'
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency 'httparty'
  spec.add_runtime_dependency 'deep_merge'

  spec.add_development_dependency 'bundler', '~> 1.6'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'webmock'
  spec.add_development_dependency 'vcr'
end
