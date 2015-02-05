Dir[File.join(Dir.pwd, 'tasks', '**', '*.rb')].each { |f| require f }

module Distribution
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
      travelling_ruby.install_native_extensions
      travelling_ruby.cleanup_files
    end

    def install_gems
      print_to_console 'Installing Gems...'

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

      FileUtils.cd Distribution.configuration.packaging_dir do
        unless File.exist? ruby
          curl "http://d6r77u77i8pq3.cloudfront.net/releases/#{ruby}"
        end
      end
    end

    def install_native_extensions
      FileUtils.mkdir_p "#{package.dir}/lib/vendor/ruby"

      package.native_extensions.each do |ext|
        FileUtils.cd "#{package.dir}/lib/vendor/ruby" do
          curl 'http://d6r77u77i8pq3.cloudfront.net/releases/' \
               "traveling-ruby-gems-#{package.rb_version}-#{package.arch}/" \
               "#{ext}.tar.gz"

          system "tar xzf #{ext}.tar.gz && rm #{ext}.tar.gz > /dev/null"
        end
      end
    end

    def cleanup_files
      FileUtils.cd package.dir do
        files  = Dir['**/{test,spec,doc,example,examples,features,benchmark}']
        files += Dir['**/{tasks,Rakefile}']
        files += Dir['lib/app/vendor/ruby/2.1.0/extensions/**/*']
        files += Dir['lib/ruby/lib/ruby/**/darkfish/images/**/*']
        files += Dir['**/*.{h,c,cpp,rl,java,class,md,rdoc,txt,gif}']
        files.each { |file| FileUtils.rm_rf file }
      end
    end
  end
end
