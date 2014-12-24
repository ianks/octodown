require 'github/markup'
require 'pygments'
require 'html/pipeline'

module Octodown
  module Renderer
    class GithubMarkdown
      attr_reader :content

      def initialize(content)
        @content = content
      end

      def to_html
        pipeline.call(content)[:output].to_s
      end

      private

      def context
        { :asset_root => 'https://assets-cdn.github.com/images/icons/'}
      end

      def pipeline
        ::HTML::Pipeline.new [
          ::HTML::Pipeline::MarkdownFilter,
          ::HTML::Pipeline::SanitizationFilter,
          ::HTML::Pipeline::ImageMaxWidthFilter,
          ::HTML::Pipeline::MentionFilter,
          ::HTML::Pipeline::EmojiFilter,
          ::HTML::Pipeline::SyntaxHighlightFilter
        ], context.merge(:gfm => true)
      end
    end
  end
end
