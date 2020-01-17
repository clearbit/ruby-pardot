# frozen_string_literal: true

require 'rubygems'
require 'cgi'
require 'tempfile'
require 'rspec'

require 'crack'
require 'httparty'

require 'ruby-pardot'

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].sort.each { |f| require f }

RSpec.configure do |config|
  config.order = :random
end
