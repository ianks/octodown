require 'fileutils'
require 'octodown'

Dir[File.join(Dir.pwd, 'tasks', '**', '*.rb')].each { |f| require f }

module Distribution
  class Package
    include PackageHelpers

    attr_reader :arch, :dir, :tarball, :version, :rb_version, :package

    def initialize(arch)
      abort 'Ruby 2.1.x required' if RUBY_VERSION !~ /^2\.1\./

      @arch = arch
      @version = Distribution.configuration.version
      @rb_version = Distribution.configuration.rb_version
      @dir = "#{Distribution.configuration.package_name}-" \
        "#{version}-#{arch}"
      @package = self
    end

    def self.create(args)
      new(*args).build
    end

    def build
      initialize_install_dir
      download_octodown
      remove_unneccesary_files
      install_ruby_and_gems
      create_executable
      post_cleanup
      @tarball = create_tarball
    end

    private

    def post_cleanup
      print_to_console 'Cleaning up...'

      files = [
        "#{Distribution.configuration.packaging_dir}/" \
        "traveling-ruby-#{rb_version}-#{arch}.tar.gz"
      ]

      files.each { |file| FileUtils.rm file if File.exist? file }
    end

    def create_tarball
      Tarball.create self
    end

    def create_executable
      Executable.create self
    end

    def install_ruby_and_gems
      TravellingRuby.install self
    end

    def remove_unneccesary_files
      FileUtils.cd "#{dir}/lib/app" do
        FileUtils.remove_dir '.git', true
        FileUtils.remove_dir 'spec', true
      end
    end

    def initialize_install_dir
      FileUtils.cd Octodown.root do
        FileUtils.remove_dir(dir, true) if File.exist? dir
        FileUtils.mkdir_p "#{dir}/lib/app"
      end
    end

    def download_octodown
      print_to_console 'Downloading octodown...'
      tar = "v#{version}.tar.gz"

      FileUtils.cd "#{dir}/lib/app" do
        curl "https://github.com/ianks/octodown/archive/#{tar}"
        system "tar --strip-components=1 -xzf #{tar} " \
          '&> /dev/null'
        FileUtils.rm tar if File.exist? tar
      end
    end
  end
end
