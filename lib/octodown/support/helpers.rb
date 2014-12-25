module Octodown
  module Support
    module Helpers
      # TODO: Find a better home for this logic
      def self.markdown_to_html(filename, template)
        unstyled_html = Octodown::Renderer::GithubMarkdown.new(filename).to_html
        html = Octodown::Renderer::HTML.new(unstyled_html, template).render
        tmp = Octodown::Support::HTMLFile.new 'octodown'
        tmp.persistent_write html
      end
    end
  end
end
