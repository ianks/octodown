require 'octodown/renderer/github_markdown'
require 'octodown/renderer/html'
require 'octodown/support/browser'
require 'octodown/support/helpers'
require 'octodown/support/relative_root_filter'
require 'octodown/support/html_file'
require 'octodown/version'

module Octodown
  def self.root
    spec = Gem::Specification.find_by_name 'octodown'
    spec.gem_dir
  end
end
