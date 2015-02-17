require 'launchy'

module Octodown
  module Support
    class Server
      DEFAULT_PORT = 8080

      attr_reader :file, :path, :options, :port

      def initialize(options = {})
        require 'rack'

        @file = ARGF.file
        @options = options
        @path = File.dirname(File.expand_path(ARGF.path))
        @port = options[:port] || DEFAULT_PORT
      end

      def start
        yield self if block_given?
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

      # Cascade through this app and Rack::File app.
      # If Server returns 404, Rack::File will try to serve a static file.
      def app
        @app ||= Rack::Cascade.new([self, Rack::File.new(path)])
      end

      private

      # Render HTML body from Markdown
      def body
        read_and_rewind file do
          markdown = Renderer::GithubMarkdown.new(file, options).to_html
          Renderer::HTML.new(markdown, options).render
        end
      end

      def read_and_rewind(file)
        file.rewind unless file.pos == 0
        yield if block_given?
      end
    end
  end # Support
end # Octodown
