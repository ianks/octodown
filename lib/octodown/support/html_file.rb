require 'tempfile'
require 'fileutils'

module Octodown
  module Support
    class HTMLFile < Tempfile
      def self.create(content)
        document = new ['octodown', '.html']
        document.persistent_write content
      end

      def persist
        ObjectSpace.undefine_finalizer self
        self
      end

      def persistent_write(content)
        write content
        close
        persist
      end
    end
  end
end
