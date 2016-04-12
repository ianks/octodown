module Octodown
  module Support
    module Services
      class Riposter
        def self.call(file, &listener_callback)
          require 'listen'

          path = File.dirname(File.expand_path(file.path))
          regex = Regexp.new(file.path)

          @listener ||= Listen.to(path, only: regex) do
            puts "Reloading #{file.path}..."
            listener_callback.call
          end

          @listener.start
        end
      end
    end
  end
end
