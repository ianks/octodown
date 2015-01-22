Dir[File.join(Dir.pwd, 'tasks', '**', '*.rb')].each { |f| require f }

module Distribution
  class Executable
    attr_reader :package

    include PackageHelpers

    def initialize(package)
      @package = package
    end

    def self.create(dir)
      executable = new(dir)
      executable.copy_wrapper
      executable
    end

    def copy_wrapper
      print_to_console 'Creating exexutable...'

      FileUtils.cp(
        'packaging/wrapper.sh',
        "#{package.dir}/#{Distribution.configuration.package_name}"
      )
    end
  end
end
