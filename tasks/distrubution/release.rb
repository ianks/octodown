Dir[File.join(Dir.pwd, 'tasks', '**', '*.rb')].each { |f| require f }

require 'octokit'
require 'pathname'

module Distribution
  class Release
    extend Forwardable
    include PackageHelpers

    attr_reader :tarball, :github, :package

    def_delegators :@tarball, :package, :version, :file

    def initialize(tarball)
      @tarball = tarball
      @github = Octokit::Client.new access_token: ENV['OCTODOWN_TOKEN']
    end

    def self.create(tarball)
      release = new(tarball)
      release.create_new_release
      release.upload_asset
    end

    def create_new_release
      print_to_console 'Publishing release to GitHub...'
      github.create_release(
        'ianks/octodown',
        "v#{version}",
        name: "v#{version}"
      )
    end

    def upload_asset
      print_to_console 'Uploading to GitHub...'
      github.upload_asset find_upload_url, file
    end

    private

    def find_upload_url
      Octokit.releases('ianks/octodown').find do |n|
        n.tag_name == version
      end[:url]
    end
  end
end
