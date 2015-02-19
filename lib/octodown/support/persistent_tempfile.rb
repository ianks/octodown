require 'tempfile'
require 'fileutils'

module Octodown
  module Support
    class PersistentTempfile < Tempfile
      def self.create(content, ext)
        document = new ['octodown', ".#{ext}"]
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
