require 'uri'

module Octodown
  module Support
    class RelativeRootFilter < HTML::Pipeline::Filter
      attr_accessor :root, :server

      def call
        @root = context[:original_document_root]
        @server = context[:server]

        filter_images doc.search('img')
        filter_links doc.search('a[href]')
      end

      private

      def relative_path_from_document_root(root, src)
        server ? src : File.join(root, src).to_s
      end

      def http_uri?(src)
        parsed_uri = begin
          URI.parse src
        rescue
          src
        end

        parsed_uri.is_a? URI::HTTP
      end

      # TODO: These two methods are highly similar and can be refactored, but
      #   I'm can't find the right abstraction at the moment that isn't a total
      #   hack involving bizarre object references and mutation

      def filter_images(images)
        images.each do |img|
          src = img['src']

          next if src.nil?

          src.strip!

          unless http_uri? src
            path = relative_path_from_document_root root, src
            img['src'] = path
          end
        end

        doc
      end

      def filter_links(links)
        links.each do |a|
          src = a.attributes['href'].value

          next if src.nil?

          src.strip!

          unless http_uri? src
            path = relative_path_from_document_root root, src
            a.attributes['href'].value = path
          end
        end

        doc
      end
    end
  end
end
