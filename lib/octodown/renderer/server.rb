require 'faye/websocket'
require 'puma'
require 'rack'
require 'rack/handler/puma'
require 'thread'
require 'launchy'

module Octodown
  module Renderer
    class Server
      attr_reader :file, :path, :options, :port, :logger

      def initialize(_content, options = {})
        @logger = options[:logger]
        @file = options[:file]
        @options = options
        @path = File.dirname(File.expand_path(file.path))
        @port = options[:port]
        @websockets = []
        @already_opened = false
        @mutex = Mutex.new
      end

      def present
        register_listener

        Thread.new do
          Thread.abort_on_exception = true
          maybe_launch_browser
          Thread.exit
        end

        boot_server
      end

      def boot_server
        logger.info "Server running on http://localhost:#{port}"
        Rack::Handler::Puma.run app, Host: 'localhost', Port: port, Silent: true
      end

      def maybe_launch_browser
        return if options[:no_open]

        sleep 2.5

        @mutex.synchronize do
          if @already_opened == false
            @already_opened = true
            logger.info 'Loading preview in a new browser tab'
            Launchy.open "http://localhost:#{port}"
          end
        end
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

      # rubocop:disable Metrics/MethodLength
      def render_ws(env)
        md = render_md(file)

        socket = ::Faye::WebSocket.new(env)

        socket.on(:open) do
          @mutex.synchronize do
            if @already_opened == false
              logger.info 'Re-using octodown client from previous browser tab'
            end

            @already_opened = true
          end

          socket.send md
          logger.debug "Clients: #{@websockets.size}"
        end

        socket.on(:close) do
          @websockets = @websockets.reject { |s| s == socket }
          logger.debug "Clients: #{@websockets.size}"
        end

        @websockets << socket
        socket.rack_response
      end
      # rubocop:enable Metrics/MethodLength

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
          logger.info 'Recompiling markdown...'
          md = render_md(file)
          @websockets.each do |socket|
            socket.send md
          end
        end
      end

      def render_md(f)
        Renderer::GithubMarkdown.render f, options
      end
    end
  end # Support
end # Octodown
