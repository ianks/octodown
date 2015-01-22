Dir[File.join(Dir.pwd, 'tasks', '**', '*.rb')].each { |f| require f }

module Distrubution
  class TravellingRuby
    attr_reader :package

    include PackageHelpers

    def initialize(package)
      @package = package
    end

    def self.install(package)
      travelling_ruby = new package
      travelling_ruby.download_runtime
      travelling_ruby.extract_to_folder
      travelling_ruby.install_gems
    end

    def install_gems
      print_to_console 'Running `bundle install`...'

      Bundler.with_clean_env do
        FileUtils.cd "#{package.dir}/lib/app" do
          system(
            'BUNDLE_IGNORE_CONFIG=1 bundle install ' \
            '--path vendor --without development --jobs 2 ' \
            '&> /dev/null'
          )
        end
      end
    end

    def extract_to_folder
      FileUtils.mkdir "#{package.dir}/lib/ruby"
      system(
        "tar -xzf packaging/traveling-ruby-#{package.rb_version}-" \
        "#{package.arch}.tar.gz " \
        "-C #{package.dir}/lib/ruby " \
        '&> /dev/null'
      )
    end

    def download_runtime
      print_to_console 'Downloading Ruby...'
      ruby = "traveling-ruby-#{package.rb_version}-#{package.arch}.tar.gz"

      FileUtils.cd Distrubution.configuration.packaging_dir do
        unless File.exist? ruby
          curl "http://d6r77u77i8pq3.cloudfront.net/releases/#{ruby}"
        end
      end
    end
  end
end
