# frozen_string_literal: true

Dir[File.join(Dir.pwd, 'tasks', '**', '*.rb')].sort.each { |f| require f }
Dir[File.join(Dir.pwd, 'tasks', '*.rake')].each { |f| load f }

require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'

RuboCop::RakeTask.new

RSpec::Core::RakeTask.new :spec do |task|
  task.rspec_opts = '--format documentation'
end

task :default => %i[spec rubocop]
