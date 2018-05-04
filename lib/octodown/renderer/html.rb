require 'erb'
require 'octodown/renderer/renderable'

module Octodown
  module Renderer
    class HTML
      include Octodown::Support
      include Renderable

      attr_reader :rendered_markdown, :filepath, :options, :logger

      def initialize(rendered_markdown, options = {})
        @logger = options[:logger]
        @rendered_markdown = rendered_markdown
        @options = options
        @filepath = File.join parent_dir, 'template', 'octodown.html.erb'
      end

      def content
        template_text = File.read filepath
        erb_template = ERB.new template_text
        erb_template.result binding
      end

      def title
        'Octodown Preview'
      end

      def stylesheet
        stylesheet = "#{options[:style]}.css"
        inject_html_node_with_file_content assets_dir(stylesheet), :style
      end

      def highlight_stylesheet
        inject_html_node_with_file_content assets_dir('highlight.css'), :style
      end

      def host
        "ws://localhost:#{options[:port]}".dump
      end

      def present
        if options[:no_open]
          logger.warn('--no-open argument was used so no browser will be opened')
        else
          Launchy.open PersistentTempfile.create(content, :html).path
        end
      end

      private

      def inject_html_node_with_file_content(name, tag)
        "<#{tag}>#{File.read name}</#{tag}>"
      end

      def assets_dir(*args)
        File.join Octodown.root, 'assets', args
      end

      def parent_dir
        current_file = File.dirname __FILE__
        File.expand_path '..', current_file
      end
    end
  end
end
