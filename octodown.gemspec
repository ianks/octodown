# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)

$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'octodown/version'
Gem::Specification.new do |spec|
  spec.name                  = 'octodown'
  spec.version               = Octodown::VERSION
  spec.authors               = ['Ian Ker-Seymer']
  spec.email                 = ['i.kerseymer@gmail.com']
  spec.summary               = 'GitHub Markdown straight from your shell.'
  spec.homepage              = 'https://github.com/ianks/octodown'
  spec.license               = 'MIT'
  spec.required_ruby_version = '>= 2.2.5'

  spec.files = Dir['{lib,assets,bin}/**/**'].reject { |f| f.end_with?('.gif') }
  spec.executables << 'octodown'
  spec.require_paths = ['lib']

  spec.add_dependency 'commonmarker',               '~> 0.17'
  spec.add_dependency 'deckar01-task_list',         '~> 2.0'
  spec.add_dependency 'faye-websocket',             '~> 0.10'
  spec.add_dependency 'gemoji',                     '>= 2', '< 4'
  spec.add_dependency 'html-pipeline',              '>= 2.8', '< 2.13'
  spec.add_dependency 'launchy',                    '~> 2.4', '>= 2.4.3'
  spec.add_dependency 'listen',                     '~> 3.7'
  spec.add_dependency 'puma',                       '>= 3.7', '< 5.0'
  spec.add_dependency 'rack',                       '~> 2.0'
  spec.add_dependency 'rouge',                      '~> 3.1'
  spec.add_dependency 'tty-prompt',                 '~> 0.16'

  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'octokit'
  spec.add_development_dependency 'rack-test', '~> 2.0'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rspec', '~> 3.3'
  spec.add_development_dependency 'rspec-retry'
  spec.add_development_dependency 'rubocop', '~> 0.55'
end
