# frozen_string_literal: true

require 'cgi'
require 'tempfile'

require 'crack'
require 'httparty'
require 'rspec'
require 'pry'

require 'ruby-pardot'

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].sort.each { |f| require f }

RSpec.configure do |config|
  config.order = :random
end
