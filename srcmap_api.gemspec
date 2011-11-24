
$:.push File.expand_path("../lib", __FILE__)
require 'version'


Gem::Specification.new do |s|
  s.name        = 'srcmap_api'
  s.version     = SrcMap::VERSION
  s.platform    = Gem::Platform::RUBY
  s.date        = '2011-11-18'
  s.summary     = "srcmap_api!"
  s.description = "This provides a basic interface for interacting with the sourcemap api server"
  s.authors     = ["Maryam Khezrzadeh"]
  s.email       = 'dev@foodtree.com'
  s.files       = ["lib/srcmap_api.rb"]
  s.homepage    =
    'http://rubygems.org/gems/srcmap_api'
    
  s.required_ruby_version = '>=1.9.2'

  s.add_dependency 'rest-client', '>= 1.6.3'
  s.add_dependency 'json'
  s.add_dependency 'i18n'
  s.add_dependency 'rspec'
    
end

