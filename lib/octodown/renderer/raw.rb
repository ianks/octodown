module Octodown
  module Renderer
    class Raw
      attr_reader :content

      def initialize(markdown, options)
        @content = HTML.new(markdown, options).content
      end

      def present
        puts content
      end
    end
  end
end
