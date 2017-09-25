require 'fileutils'
require 'forwardable'

Dir[File.join(Dir.pwd, 'tasks', '**', '*.rb')].each { |f| require f }

module Distribution
  class Package
    extend Forwardable
    include PackageHelpers

    attr_reader :config, :dir, :tarball, :package, :arch, :root

    def_delegators :@config, :version, :rb_version, :package_name,
                   :packaging_dir, :native_extensions

    def initialize(arch)
      abort 'Ruby 2.1.x required' if RUBY_VERSION !~ /^2\.1\./

      @arch = arch
      @config = ::Distribution.configuration
      @dir = "#{package_name}-#{version}-#{arch}"
      @package = self
      @root = File.expand_path '.'
    end

    def self.create(args)
      new(*args).build
    end

    def build
      initialize_install_dir
      copy_octodown
      install_ruby_and_gems
      create_executable
      post_cleanup
      @tarball = create_tarball
      clean_dir
    end

    private

    def clean_dir
      FileUtils.cd root do
        FileUtils.remove_dir(dir, true) if Dir.exist? dir
      end
    end

    def post_cleanup
      print_to_console 'Cleaning up...'

      files = ["#{packaging_dir}/traveling-ruby-#{rb_version}-#{arch}.tar.gz"]

      files.each { |file| FileUtils.rm file if File.exist? file }
    end

    def create_tarball
      Tarball.new self
    end

    def create_executable
      Executable.create self
    end

    def install_ruby_and_gems
      TravellingRuby.install self
    end

    def initialize_install_dir
      clean_dir

      FileUtils.cd root do
        FileUtils.mkdir_p "#{dir}/lib/app"
      end
    end

    def copy_octodown
      print_to_console 'Copying octodown...'

      %w[octodown.gemspec Gemfile LICENSE.txt lib assets bin]
        .each do |folder|
        FileUtils.cp_r File.join(root, folder), "#{dir}/lib/app"
      end
    end
  end
end
