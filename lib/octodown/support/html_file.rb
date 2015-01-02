require 'tempfile'
require 'fileutils'

module Octodown
  module Support
    class HTMLFile < Tempfile
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
