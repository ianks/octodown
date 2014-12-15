require 'coderay'
require 'redcarpet'

module Octodown
  module Renderer
    module Markdown
      class Redcarpet
        attr_reader :text

        def initialize(text)
          @text = text
        end

        def to_html
          ::Redcarpet::Markdown.new(renderer, options).render(text)
        end

        private

        def options
          {
            fenced_code_blocks: true,
            no_intra_emphasis: true,
            autolink: true,
            strikethrough: true,
            lax_html_blocks: true,
            superscript: true
          }
        end

        def renderer
          HTMLwithSyntaxHighlighting.new(filter_html: true, hard_wrap: true)
        end
      end
    end
  end
end

class HTMLwithSyntaxHighlighting < Redcarpet::Render::HTML
  def block_code(code, language)
    language = :text if language.nil?
    CodeRay.scan(code, language).div
  end
end
