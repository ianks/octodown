Dir[File.join(Dir.pwd, 'tasks', '**', '*.rb')].each { |f| require f }

require 'digest'
require 'erb'

module Distribution
  class ReleaseNotes
    extend Forwardable

    attr_reader :version, :content

    def initialize
      @version = `git tag | tail -1`.strip
      @content = render_template
    end

    private

    def render_template
      template_text = File.read 'tasks/distribution/release_notes.erb'
      erb_template = ERB.new template_text
      erb_template.result binding
    end

    # Show our committers
    def committers
      prev_tag = `git tag | tail -2 | head -1`.strip
      `git log #{prev_tag}.. --format="%aN"`
        .split("\n")
        .uniq
        .sort
        .map { |str| "- #{str}" }
        .join "\n"
    end

    # Generate text for shasums
    def shasums
      Dir['distro/*'].reduce '' do |a, e|
        [].tap do |arr|
          arr << a
          arr << "#{File.basename e}: "
          arr << ' ' * (36 - arr[1].size)
          arr << "#{Digest::SHA256.hexdigest File.read(e)}\n"
        end.join
      end
    end
  end
end
