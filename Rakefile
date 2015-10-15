Dir[File.join(Dir.pwd, 'tasks', '**', '*.rb')].each { |f| require f }
Dir[File.join(Dir.pwd, 'tasks', '*.rake')].each { |f| load f }

require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'

RuboCop::RakeTask.new

RSpec::Core::RakeTask.new :spec do |task|
  task.rspec_opts = '--format documentation'
end

Distribution.configure do |config|
  config.package_name = 'octodown'
  config.version = Octodown::VERSION
  config.rb_version = '20150210-2.1.5'
  config.packaging_dir = File.expand_path 'packaging'
  config.native_extensions = [
    'rugged-0.24.0b0',
    'nokogumbo-1.4.1',
    'github-markdown-0.6.9',
    'escape_utils-1.1.0',
    'charlock_holmes-0.7.3',
    'thin-1.6.4',
    'eventmachine-1.0.8',
    'ffi-1.9.10'
  ]
end

task :default => [:spec, :rubocop]
