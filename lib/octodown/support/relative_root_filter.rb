require 'uri'

module Octodown
  module Support
    class RelativeRootFilter < HTML::Pipeline::Filter
      def call
        doc.search('img').each do |img|
          next if img['src'].nil?

          src = img['src'].strip

          img['src'] = relative_path_from_document_root src unless http_uri? src
        end

        doc
      end

      def relative_path_from_document_root(src)
        File.join(context[:original_document_root], src).to_s
      end

      def http_uri?(src)
        parsed_uri = URI.parse src
        parsed_uri.is_a? URI::HTTP
      end
    end
  end
end
