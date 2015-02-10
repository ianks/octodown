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
  config.packaging_dir = "#{Octodown.root}/packaging"
  config.native_extensions = [
    'rugged-0.21.4',
    'posix-spawn-0.3.9',
    'nokogumbo-1.3.0',
    'github-markdown-0.6.8',
    'escape_utils-1.0.1',
    'charlock_holmes-0.7.3'
  ]
end

task :default => [:spec, :rubocop]
