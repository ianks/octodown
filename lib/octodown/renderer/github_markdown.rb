require 'github/markup'
require 'html/pipeline'
require 'html/pipeline/rouge_filter'
require 'octodown/renderer/renderable'

module Octodown
  module Renderer
    class GithubMarkdown
      include HTML
      include Renderable

      attr_reader :options, :file

      def initialize(file, options = {})
        @file = file
        @options = options
      end

      def content
        if file == STDIN
          buffer = file.read
        else
          begin
            File.open(file.path, 'r') { |f| buffer = f.read }
          rescue Errno::ENOENT
            puts '[WARN] something went wrong when trying to open the file'
          end
        end
        pipeline.call(buffer ||= 'could not read changes')[:output].to_s
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
          Pipeline::ImageMaxWidthFilter,
          Pipeline::MentionFilter,
          Pipeline::EmojiFilter,
          Pipeline::RougeFilter
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
