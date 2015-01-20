# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'copperegg/version'

Gem::Specification.new do |spec|
  spec.name = 'copperegg-alerts'
  spec.version = Copperegg::VERSION
  spec.summary = 'A very minimalistic Copperegg API client for managing alert schedules'
  spec.description = 'Set and remove alert silencing schedules aka maintenance windows'
  spec.authors = ['Cargo Media', 'ppp0']
  spec.email = 'hello@cargomedia.ch'
  spec.files = Dir['LICENSE*', 'README*', 'lib/**/*']
  spec.executables = []
  spec.homepage = 'https://github.com/cargomedia/copperegg-alerts'
  spec.license = 'MIT'

  spec.add_runtime_dependency 'httparty', '~> 0.13.1'
  spec.add_runtime_dependency 'deep_merge', '~> 1.0.1'

  spec.add_development_dependency 'bundler', '~> 1.6'
  spec.add_development_dependency 'rake', '~> 10.3.2'
  spec.add_development_dependency 'rspec', '~> 3.1.0'
  spec.add_development_dependency 'webmock', '~> 1.18.0'
  spec.add_development_dependency 'vcr', '~> 2.9.3'
  spec.add_development_dependency 'hashdiff', '~> 0.2.1'
end
