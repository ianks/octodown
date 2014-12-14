require 'true_github_markdown/version'
require 'true_github_markdown/renderer/markdown/github'
require 'true_github_markdown/renderer/markdown/redcarpet'
require 'true_github_markdown/renderer/html'

module TrueGithubMarkdown
  def self.root
    spec = Gem::Specification.find_by_name 'true_github_markdown'
    spec.gem_dir
  end
end
