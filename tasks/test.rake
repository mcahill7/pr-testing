require 'rake'
require 'rspec/core/rake_task'

desc 'Run tests'
RSpec::Core::RakeTask.new('demo:test') do |t|
  t.pattern = 'spec/*_spec.rb'
end
