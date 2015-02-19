require 'github/markup'
require 'pygments'
require 'html/pipeline'
require 'octodown/renderer/renderable'

module Octodown
  module Renderer
    class GithubMarkdown
      include HTML
      include Renderable

      attr_reader :content, :document_root, :options, :file

      def initialize(file, options = {})
        @file = file
        @document_root = File.dirname File.expand_path(file.path)
        @options = options
      end

      def content
        pipeline.call(file.read)[:output].to_s
      end

      private

      def context
        {
          asset_root: 'https://assets-cdn.github.com/images/icons/',
          server: options[:presenter] == :server,
          original_document_root: document_root
        }
      end

      def pipeline
        Pipeline.new [
          Pipeline::MarkdownFilter,
          Support::RelativeRootFilter,
          Pipeline::SanitizationFilter,
          Pipeline::ImageMaxWidthFilter,
          Pipeline::MentionFilter,
          Pipeline::EmojiFilter,
          Pipeline::SyntaxHighlightFilter
        ], context.merge(gfm: options[:gfm])
      end
    end
  end
end
