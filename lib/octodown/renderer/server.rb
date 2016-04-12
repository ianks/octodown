module Octodown
  module Renderer
    class Server
      attr_reader :file, :path, :options, :port

      def initialize(_content, options = {})
        init_ws

        @file = ARGF.file
        @options = options
        @path = File.dirname(File.expand_path(file.path))
        @port = options[:port]
        @websockets = []
      end

      def present
        register_listener

        # We need to make sure the server has started before opening the
        # page in a browser. I hate relying on time here, but I can't think
        # of cleaner way currently.
        Thread.new do |t|
          sleep 2.5
          Launchy.open "http://localhost:#{port}" if @websockets.empty?
          t.exit
        end

        Rack::Server.start app: app, Port: port
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
        md = render_md(file)

        socket = ::Faye::WebSocket.new(env)

        socket.on(:open) do
          socket.send md
          puts "Clients: #{@websockets.size}" if ENV['DEBUG']
        end
        socket.on(:close) do
          @websockets = @websockets.select { |s| s != socket }
          puts "Clients: #{@websockets.size}" if ENV['DEBUG']
        end

        @websockets << socket
        socket.rack_response
      end

      def render_http(env)
        Rack::Response.new.tap do |res|
          res.headers.merge 'Content-Type' => 'text/html'
          res.status = valid_req?(env) ? 200 : 404
          res.write(body) if valid_req? env
        end.finish
      end

      def valid_req?(env)
        env['PATH_INFO'] == '/' && env['REQUEST_METHOD'] == 'GET'
      end

      # Render HTML body from Markdown
      def body
        HTML.render render_md(file), options
      end

      def register_listener
        Octodown::Support::Services::Riposter.call file do
          md = render_md(file)
          @websockets.each do |socket|
            socket.send md
          end
        end
      end

      def render_md(f)
        f.rewind unless f.pos == 0
        Renderer::GithubMarkdown.render f, options
      end

      def init_ws
        require 'rack'
        require 'faye/websocket'

        Faye::WebSocket.load_adapter 'thin'
      end
    end
  end # Support
end # Octodown
