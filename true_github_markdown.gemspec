# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'true_github_markdown/version'

Gem::Specification.new do |spec|
  spec.name          = "true_github_markdown"
  spec.version       = TrueGithubMarkdown::VERSION
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
  spec.add_dependency "redcarpet"
  spec.add_dependency "coderay"
end
