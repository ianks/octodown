Dir[File.join(Dir.pwd, 'tasks', '**', '*.rb')].each { |f| require f }

require 'octokit'
require 'pathname'

module Distrubution
  class Release
    attr_reader :tarball, :github, :package

    include PackageHelpers

    def initialize(tarball)
      @tarball = tarball
      @package = tarball.package
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
        "v#{tarball.version}",
        name: "v#{tarball.version}"
      )
    end

    def upload_asset
      print_to_console 'Uploading to GitHub...'
      github.upload_asset(
        find_upload_url(tarball.version),
        tarball.file
      )
    end

    private

    def find_upload_url(version)
      Octokit.releases('ianks/octodown').find do |n|
        n.tag_name == version
      end[:url]
    end
  end
end
