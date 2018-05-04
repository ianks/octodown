module Octodown
  module Support
    module Services
      class Riposter
        def self.call(file, &listener_callback)
          require 'listen'

          path = File.dirname(File.expand_path(file.path))
          escaped_path = Regexp.escape(file.path)
          regex = Regexp.new("^#{escaped_path}$")

          @listener ||= Listen.to(path, only: regex) do |modified, added, _rm|
            listener_callback.call if modified.any? || added.any?
          end

          @listener.start
        end
      end
    end
  end
end
