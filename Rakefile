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
  config.rb_version = '20141215-2.1.5'
  config.packaging_dir = "#{Octodown.root}/packaging"
end

task :default => [:spec, :rubocop]
