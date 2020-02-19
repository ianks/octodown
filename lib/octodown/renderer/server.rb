# frozen_string_literal: true

require 'faye/websocket'
require 'puma'
require 'rack'
require 'rack/handler/puma'
require 'launchy'

module Octodown
  module Renderer
    class Server
      Thread.abort_on_exception = true

      attr_reader :file, :path, :options, :port, :logger

      def initialize(_content, options = {})
        @logger = options[:logger]
        @file = options[:file]
        @options = options
        @path = File.dirname(File.expand_path(file.path))
        @port = options[:port]
        @websockets = []
        @mutex = Mutex.new
      end

      def present
        register_listener

        Thread.new do
          maybe_launch_browser
        end

        boot_server
      end

      def boot_server
        logger.info "#{file.path} is getting octodown'd"
        logger.info "Server running on http://localhost:#{port}"
        Rack::Handler::Puma.run app,
                                Host: 'localhost',
                                Port: port,
                                Silent: true,
                                Threads: '2:8'
      end

      def maybe_launch_browser
        return if options[:no_open]

        sleep 2.5

        @mutex.synchronize do
          if @websockets.empty?
            logger.info 'Loading preview in a new browser tab'
            Launchy.open "http://localhost:#{port}"
          else
            logger.info 'Re-using existing browser tab'
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

      def render_ws(env)
        md = render_md(file)

        socket = ::Faye::WebSocket.new(env)

        socket.on(:open) do
          @websockets << socket
          log_clients('Client joined')
          socket.send md
        end

        socket.on(:close) do
          @websockets = @websockets.reject { |s| s == socket }
          log_clients('Client left')
        end

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
          logger.info "Changes to #{file.path} detected, updating"
          md = render_md(file)
          @websockets.each do |socket|
            Thread.new do
              socket.send md
            end
          end
        end
      end

      def render_md(f)
        Renderer::GithubMarkdown.render f, options
      end

      def log_clients(msg)
        logger.debug "#{msg}. Number of websocket clients: #{@websockets.size}"
      end
    end
  end # Support
end # Octodown
