module Octodown
  module Support
    class Server
      DEFAULT_PORT = 8080

      attr_reader :file, :path, :options, :port, :ws

      def initialize(options = {})
        init_ws

        @file = ARGF.file
        @options = options
        @path = File.dirname(File.expand_path(file.path))
        @port = options[:port] || DEFAULT_PORT
      end

      def start
        register_listener
        yield self if block_given?
        Rack::Server.start(app: app, Port: port)
      end

      def call(env)
        ::Faye::WebSocket.websocket?(env) ? render_ws(env) : render_http(env)
      end

      # Cascade through this app and Rack::File app.
      # If Server returns 404, Rack::File will try to serve a static file.
      def app
        @app ||= Rack::Cascade.new([self, Rack::File.new(path)])
      end

      private

      def render_ws(env)
        @ws = ::Faye::WebSocket.new env
        ws.rack_response
      end

      def render_http(env)
        res = Rack::Response.new
        res.headers['Content-Type'] = 'text/html'

        if env['PATH_INFO'] == '/'
          res.write(body) if env['REQUEST_METHOD'] == 'GET'
        else
          res.status = 404
        end

        res.finish
      end

      # Render HTML body from Markdown
      def body
        Renderer::HTML.new(render_md, options).render
      end

      def register_listener
        Services::Riposter.call file do
          ws.send render_md
          puts "Reloading #{file.path}..."
        end
      end

      def render_md
        file.rewind unless file.pos == 0
        Renderer::GithubMarkdown.new(file, options).to_html
      end

      def init_ws
        require 'rack'
        require 'faye/websocket'

        Faye::WebSocket.load_adapter 'thin'
      end
    end
  end # Support
end # Octodown
