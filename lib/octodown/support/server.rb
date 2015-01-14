module Octodown
  module Support
    class Server
      DEFAULT_PORT = 8080

      def initialize(content, options, path)
        require 'rack'

        @content = content
        @options = options
        @path = path
      end

      def start
        Rack::Server.start(app: app, Port: port)
      end

      def call(env)
        res = Rack::Response.new
        res.headers['Content-Type'] = 'text/html'

        if env['PATH_INFO'] == '/'
          res.write(body) if env['REQUEST_METHOD'] == 'GET'
        else
          res.status = 404
        end

        res.finish
      end

      def app
        # Cascade through this app and Rack::File app.
        # If Server returns 404, Rack::File will try to serve a static file.
        @app ||= Rack::Cascade.new([self, Rack::File.new(@path)])
      end

      private

      def body
        # Render HTML body from Markdown
        # Use / as document root to generate URLs with relative paths
        Octodown::Support::Helpers
          .markdown_to_raw_html(@content, @options, '/')
      end

      def port
        @options[:port] || DEFAULT_PORT
      end
    end
  end # Support
end # Octodown
