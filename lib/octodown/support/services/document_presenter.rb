module Octodown
  module Support
    module Services
      class DocumentPresenter
        def self.call(file, options)
          include Octodown::Renderer

          rendered_markdown = GithubMarkdown.new(file, options).to_html

          case options[:presenter]
          when :raw    then Raw
          when :pdf    then PDF
          when :html   then HTML
          when :server then Server
          end.new(rendered_markdown, options).present
        end
      end
    end
  end
end
