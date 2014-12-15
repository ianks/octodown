require 'octodown/version'
require 'octodown/renderer/github_markdown'
require 'octodown/renderer/html'

module Octodown
  def self.root
    spec = Gem::Specification.find_by_name 'octodown'
    spec.gem_dir
  end
end
