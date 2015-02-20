require 'github/markup'
require 'pygments'
require 'html/pipeline'
require 'octodown/renderer/renderable'

module Octodown
  module Renderer
    class GithubMarkdown
      include HTML
      include Renderable

      attr_reader :content, :options, :file

      def initialize(file, options = {})
        @file = file
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

      def document_root
        case file
        when STDIN then Dir.pwd
        else File.dirname File.expand_path(file.path)
        end
      end
    end
  end
end
