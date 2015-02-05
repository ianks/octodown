Dir[File.join(Dir.pwd, 'tasks', '**', '*.rb')].each { |f| require f }

module Distribution
  class Tarball
    include PackageHelpers
    extend Forwardable

    attr_accessor :arch, :file, :version, :dir, :package

    def_delegators :@package, :arch, :dir

    def initialize(package)
      @package = package
      @file = search || build
      @version = extract_version
    end

    def self.upload(package)
      new(package).to_github
    end

    def to_github
      Release.new(self).upload_asset
    end

    def build
      print_to_console 'Creating tarball...'

      FileUtils.mkdir_p 'distro'
      system "tar -czf distro/#{dir}.tar.gz #{dir} > /dev/null"
      FileUtils.remove_dir "#{dir}", true

      File.new "distro/#{dir}.tar.gz"
    end

    private

    def search
      ball = Dir['distro/*.tar.gz'].find { |n| n.include? "#{arch}.tar.gz" }
      File.new ball unless ball.nil?
    end

    def extract_version
      file.path.match(/\*|\d+(\.\d+){0,2}(\.\*)?/)[0]
    end
  end
end
