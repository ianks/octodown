module Octodown
  module Support
    module Services
      class DocumentPresenter
        def self.call(html_string, options)
          new.browser_open do
            if options[:raw]
              puts html_string
            elsif options[:server]
              Server.new(options).start
              'http://localhost:8080'
            else
              HTMLFile.create(html_string).path
            end
          end
        end

        def browser_open
          dest = yield if block_given?
          Launchy.open dest unless dest.nil?
        end
      end
    end
  end
end
