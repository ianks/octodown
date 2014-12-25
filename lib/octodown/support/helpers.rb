module Octodown
  module Support
    module Helpers
      # TODO: Find a better home for this logic
      def self.markdown_to_html(contents, template)
        html = markdown_to_raw_html(contents, template)
        tmp = Octodown::Support::HTMLFile.new 'octodown'
        tmp.persistent_write html
      end

      def self.markdown_to_raw_html(contents, template)
        unstyled_html = Octodown::Renderer::GithubMarkdown.new(contents).to_html
        Octodown::Renderer::HTML.new(unstyled_html, template).render
      end
    end
  end
end
