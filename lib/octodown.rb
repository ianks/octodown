require 'octodown/renderer/github_markdown'
require 'octodown/renderer/html'
require 'octodown/support/services/document_presenter'
require 'octodown/support/services/riposter'
require 'octodown/support/relative_root_filter'
require 'octodown/support/html_file'
require 'octodown/support/pdf_file'
require 'octodown/support/server'
require 'octodown/version'

module Octodown
  def self.call(options)
    include Octodown::Support::Services

    rendered_markdown = Renderer::GithubMarkdown.new(ARGF.file, options).to_html
    html_string = Renderer::HTML.new(rendered_markdown, options).render

    DocumentPresenter.call html_string, options
  end

  def self.root
    Gem::Specification.find_by_name('octodown').gem_dir
  end
end
