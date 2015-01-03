module Octodown
  module Support
    module Helpers
      include Octodown::Renderer

      # TODO: Find a better home for this logic
      def self.markdown_to_html(content, template, path)
        html = markdown_to_raw_html(content, template, path)
        tmp = Octodown::Support::HTMLFile.new 'octodown'
        tmp.persistent_write html
      end

      def self.markdown_to_raw_html(content, template, path)
        unstyled_html = GithubMarkdown.new(content, path).to_html
        HTML.new(unstyled_html, template).render
      end
    end
  end
end
