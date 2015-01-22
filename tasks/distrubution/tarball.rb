Dir[File.join(Dir.pwd, 'tasks', '**', '*.rb')].each { |f| require f }

module Distribution
  class Tarball
    attr_accessor :arch, :file, :version, :dir, :package

    include PackageHelpers

    def initialize(package)
      @package = package
      @arch = package.arch
      @dir = package.dir
      @file = search
      @version = extract_version
    end

    def self.create(package)
      ball = new package
      ball.build
      ball
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
    end

    private

    def search
      file = Dir['distro/*.tar.gz'].find { |n| n.include? "#{arch}.tar.gz" }
      File.new file
    end

    def extract_version
      file.path.match(/\*|\d+(\.\d+){0,2}(\.\*)?/)[0]
    end
  end
end
