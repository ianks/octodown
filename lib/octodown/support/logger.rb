require 'logger'

module Octodown
  module Support
    class Logger
      FORMAT = "%-5s: %s\n".freeze

      def self.build(dev: STDOUT, level: ::Logger::INFO)
        dev.sync = true
        logger = ::Logger.new(dev)
        logger.level = level
        logger.formatter = method(:formatter)
        logger
      end

      def self.formatter(severity, _datetime, _progname, msg)
        format(FORMAT, severity, msg)
      end
    end
  end
end
