module Distribution
  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield configuration
  end

  class Configuration
    attr_accessor :package_name, :packaging_dir, :version, :rb_version,
                  :native_extensions
  end
end
