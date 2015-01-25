Dir[File.join(Dir.pwd, 'tasks', '**', '*.rb')].each { |f| require f }

module Distribution
  class Executable
    include PackageHelpers
    extend Forwardable

    attr_reader :package

    def_delegators :@package, :dir, :package_name

    def initialize(package)
      @package = package
    end

    def self.create(package)
      executable = new(package)
      executable.copy_wrapper
      executable
    end

    def copy_wrapper
      print_to_console 'Creating exexutable...'

      FileUtils.cp 'packaging/wrapper.sh', "#{dir}/#{package_name}"
    end
  end
end
