require 'tempfile'
require 'fileutils'
require 'pdfkit'

module Octodown
  module Support
    class PDFFile < Tempfile
      def self.create(content)
        document = new ['octodown', '.pdf']
        document.persistent_write content
      end

      def persist
        ObjectSpace.undefine_finalizer self
        self
      end

      def persistent_write(content)
        write convert_to_pdf(content)
        close
        persist
      end

      def convert_to_pdf(content)
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
