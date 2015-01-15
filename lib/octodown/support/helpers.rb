module Octodown
  module Support
    module Helpers
      include Octodown::Renderer

      # TODO: Find a better home for this logic
      def self.markdown_to_html(content, options, path)
        html = markdown_to_raw_html(content, options, path)
        tmp = Octodown::Support::HTMLFile.new ['octodown', '.html']
        tmp.persistent_write html
      end

      def self.markdown_to_raw_html(content, options, path)
        rendered_markdown = GithubMarkdown.new(content, path, options).to_html
        HTML.new(rendered_markdown, options).render
      end
    end
  end
end
