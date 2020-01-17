# frozen_string_literal: true

require File.expand_path('lib/pardot/version', __dir__)

Gem::Specification.new do |s|
  s.name        = 'ruby-pardot'
  s.version     = Pardot::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Dan Cunning']
  s.email       = ['support@pardot.com']
  s.homepage    = 'http://github.com/pardot/ruby-pardot'
  s.summary     = 'Library for interacting with the Pardot API'
  s.description = 'Library for interacting with the Pardot API'

  s.required_rubygems_version = '>= 1.3.6'

  s.add_dependency 'crack', '0.4.3'
  s.add_dependency 'httparty', '0.13.1'

  s.add_development_dependency 'bundler', '>= 1.10'
  s.add_development_dependency 'fakeweb'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'rubocop'

  s.files        = `git ls-files -z`.split("\x0").grep(/lib|README\.rdoc/)
  s.require_path = 'lib'
end
