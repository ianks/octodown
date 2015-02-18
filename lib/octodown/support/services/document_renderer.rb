module Octodown
  module Support
    module Services
      class DocumentRenderer
        def self.call(file, options)
          include Octodown::Renderer

          rendered_markdown = GithubMarkdown.new(file, options).to_html

          case options[:presenter]
          when :pdf  then PDF
          when :html then HTML
          end.new(rendered_markdown, options).content
        end
      end
    end
  end
end
