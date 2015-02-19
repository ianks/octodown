require 'octodown/renderer/renderable'
require 'octodown/support/persistent_tempfile'
require 'octodown/renderer/github_markdown'
require 'octodown/renderer/html'
require 'octodown/renderer/pdf'
require 'octodown/renderer/raw'
require 'octodown/renderer/server'
require 'octodown/support/relative_root_filter'
require 'octodown/support/services/document_presenter'
require 'octodown/support/services/riposter'
require 'octodown/version'

module Octodown
  def self.call(options)
    include Octodown::Support::Services

    DocumentPresenter.call ARGF.file, options
  end

  def self.root
    Gem::Specification.find_by_name('octodown').gem_dir
  end
end
