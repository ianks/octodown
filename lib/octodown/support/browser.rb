module Octodown
  module Support
    class Browser
      def initialize
        @cmd = determine_browser_open_cmd
      end

      def open(file)
        out_file = File.open('/dev/null').fileno
        Process.spawn cmd, file.path, [:out, :err] => out_file
      end

      private

      attr_reader :cmd

      def determine_browser_open_cmd
        open_in_browser_candidates.detect { |cmd| File.exists? cmd }
      end

      def open_in_browser_candidates
        # TODO: More robust detection for OS
        if RUBY_PLATFORM.include? 'darwin'
          %w(/usr/bin/open)
        elsif RUBY_PLATFORM.include? 'linux'
          %w(/usr/bin/xdg-open /usr/bin/x-www-browser)
        else
          %w(start)
        end
      end
    end
  end
end
