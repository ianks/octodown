require 'github/markup'
require 'pygments'
require 'html/pipeline'

module Octodown
  module Renderer
    class GithubMarkdown
      attr_reader :content, :document_root, :gfm

      def initialize(content, document_root, options = {})
        @content = content
        @document_root = document_root
        @gfm = options[:gfm] || false
      end

      def to_html
        pipeline.call(content)[:output].to_s
      end

      private

      def context
        {
          :asset_root => 'https://assets-cdn.github.com/images/icons/',
          :original_document_root => document_root
        }
      end

      def pipeline
        ::HTML::Pipeline.new [
          ::HTML::Pipeline::MarkdownFilter,
          ::Octodown::Support::RelativeRootFilter,
          ::HTML::Pipeline::SanitizationFilter,
          ::HTML::Pipeline::ImageMaxWidthFilter,
          ::HTML::Pipeline::MentionFilter,
          ::HTML::Pipeline::EmojiFilter,
          ::HTML::Pipeline::SyntaxHighlightFilter
        ], context.merge(:gfm => gfm)
      end
    end
  end
end
