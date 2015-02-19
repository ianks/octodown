module Octodown
  module Renderer
    class PDF
      include Octodown::Support

      attr_reader :content

      def initialize(content, _options)
        @content = to_pdf content
      end

      def present
        Launchy.open PersistentTempfile.create(content, :pdf).path
      end

      private

      def to_pdf(content)
        require 'pdfkit'

        PDFKit.new(content).to_pdf
      rescue PDFKit::NoExecutableError
        abort <<-MSG.gsub(/^\s+/, '')
          wkhtmltopdf must be installed in order to use the --pdf option
          Try: gem install wkhtmltopdf-binary
        MSG
      end
    end
  end
end
