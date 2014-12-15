# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'octodown/version'

Gem::Specification.new do |spec|
  spec.name          = "octodown"
  spec.version       = Octodown::VERSION
  spec.authors       = ["Ian Ker-Seymer"]
  spec.email         = ["i.kerseymer@gmail.com"]
  spec.summary       = %q{Simple markdown preview for VIM.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"

  spec.add_dependency "github-markup"
  spec.add_dependency "github-linguist"
  spec.add_dependency "html-pipeline"
  spec.add_dependency "sanitize"
  spec.add_dependency "github-markdown"
  spec.add_dependency "gemoji"
  spec.add_dependency "pygments.rb"
end
