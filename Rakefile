require 'bundler/gem_tasks'

begin
  require 'rspec/core/rake_task'

  RSpec::Core::RakeTask.new(:spec)

  task default: :spec
rescue LoadError
  # Ignore outside test envrionment.
end
