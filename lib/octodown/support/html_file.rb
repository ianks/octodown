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
        self.write content
        self.close
        self.persist
      end
    end
  end
end
