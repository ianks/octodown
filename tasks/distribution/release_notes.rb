Dir[File.join(Dir.pwd, 'tasks', '**', '*.rb')].each { |f| require f }

require 'digest'
require 'erb'
require 'octokit'

module Distribution
  class ReleaseNotes
    attr_reader :version, :content, :github

    def initialize
      @version = `git tag | tail -1`.strip
      @github = Octokit::Client.new access_token: ENV['OCTODOWN_TOKEN']
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
      committer_logins_for(contributor_emails)
        .map { |str| "- @#{str}" }
        .join "\n"
    end

    def contributor_emails
      `git log #{prev_release}.. --format="%aE"`
        .split("\n")
        .uniq
    end

    def committer_logins_for(emails)
      emails.map do |email|
        github.search_users("#{email} in:email")
          .items
          .first
          .login
      end
    end

    def prev_release
      `git tag | tail -2 | head -1`.strip
    end

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
