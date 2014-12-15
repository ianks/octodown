require 'github/markup'
require 'pygments'
require 'html/pipeline'

module Octodown
  module Renderer
    class GithubMarkdown
      attr_reader :file

      def initialize(file)
        @file = File.read file
      end

      def to_html
        pipeline.call(file)[:output].to_s
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
