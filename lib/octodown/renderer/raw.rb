require 'octodown/renderer/renderable'

module Octodown
  module Renderer
    class Raw
      include Renderable

      attr_reader :content

      def initialize(markdown, options)
        @content = HTML.render markdown, options
      end

      def present
        puts content
      end
    end
  end
end
