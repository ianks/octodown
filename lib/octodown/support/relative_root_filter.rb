require 'uri'

module Octodown
  module Support
    class RelativeRootFilter < HTML::Pipeline::Filter
      def call
        doc.search('img').each do |img|
          next if img['src'].nil?

          src = img['src'].strip
          root = context[:original_document_root]

          unless http_uri? src
            img['src'] = relative_path_from_document_root root, src
          end
        end

        doc
      end

      def relative_path_from_document_root(root, src)
        File.join(root, src).to_s
      end

      def http_uri?(src)
        parsed_uri = URI.parse src
        parsed_uri.is_a? URI::HTTP
      end
    end
  end
end
