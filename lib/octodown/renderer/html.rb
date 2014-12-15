require 'erb'

module Octodown
  module Renderer
    class HTML
      attr_reader :rendered_markdown, :template

      def initialize(rendered_markdown, template: 'github')
        @rendered_markdown = rendered_markdown
        @template = template
      end

      def render
        template_text = File.read template_filepath
        erb_template = ERB.new template_text
        erb_template.result binding
      end

      def title
        'True Github Markdown Preview'
      end

      def stylesheet
        stylesheet_file = File.join Octodown.root, 'assets',
          "#{template}.css"
        File.read stylesheet_file
      end

      private

      def parent_dir
        current_file = File.dirname __FILE__
        File.expand_path '..', current_file
      end

      def template_filepath
        File.join parent_dir, 'template', "#{template}.erb"
      end
    end
  end
end
