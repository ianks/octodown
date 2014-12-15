require 'net/http'
require 'json'
require 'uri'

module Octodown
  module Renderer
    module Markdown
      class Github
        attr_reader :text, :request, :mode

        @@uri = URI 'https://api.github.com/markdown'

        def initialize(text, mode: 'gfm')
          @text = text
          @mode = mode
        end

        def to_html
          req = Net::HTTP::Post.new @@uri.path, initheader = headers
          req.body = payload

          Net::HTTP.start @@uri.hostname, @@uri.port, use_ssl: true do |https|
            https.verify_mode = OpenSSL::SSL::VERIFY_NONE
            https.ssl_version = :SSLv3
            https.request req
          end.body
        end

        private

        def headers
          { 'Content-Type' =>'text/json' }
        end

        def payload
          { text: text, mode: mode }.to_json
        end
      end
    end
  end
end
