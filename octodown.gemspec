# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'octodown/version'

Gem::Specification.new do |spec|
  spec.name          = 'octodown'
  spec.version       = Octodown::VERSION
  spec.authors       = ['Ian Ker-Seymer']
  spec.email         = ['i.kerseymer@gmail.com']
  spec.summary       = 'GitHub Markdown straight from your shell.'
  spec.homepage      = 'https://github.com/ianks/octodown'
  spec.license       = 'MIT'

  spec.files         = Dir['{lib,assets,bin}/**/*']
  spec.executables   << 'octodown'
  spec.require_paths = ['lib']

  spec.add_dependency 'github-markup',       '~> 1.3.1'
  spec.add_dependency 'github-linguist',     '~> 4.2.5'
  spec.add_dependency 'html-pipeline',       '~> 1.11.0'
  spec.add_dependency 'sanitize',            '~> 3.1.0'
  spec.add_dependency 'github-markdown',     '~> 0.6.8'
  spec.add_dependency 'gemoji',              '~> 2.1.0'
  spec.add_dependency 'pygments.rb',         '~> 0.6.0'
  spec.add_dependency 'launchy',             '~> 2.4.3'
  spec.add_dependency 'rack',                '~> 1.6.0'
  spec.add_dependency 'thin',                '~> 1.6.3'
  spec.add_dependency 'listen',              '~> 2.8.5'
  spec.add_dependency 'faye-websocket',      '~> 0.9.2'

  spec.add_development_dependency 'rspec',     '~> 3.1.0'
  spec.add_development_dependency 'rubocop',   '~> 0.28.0'
  spec.add_development_dependency 'bundler',   '~> 1.7'
  spec.add_development_dependency 'rake',      '~> 10.0'
  spec.add_development_dependency 'rack-test', '~> 0.6.3'
  spec.add_development_dependency 'octokit'
end
