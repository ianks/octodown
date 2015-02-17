module Octodown
  module Support
    module Services
      class DocumentPresenter
        def self.call(html_string, options)
          if options[:raw]
            puts html_string
          elsif options[:server]
            Server.new(options).start do |s|
              Launchy.open "http://localhost:#{s.port}"
            end
          else
            Launchy.open HTMLFile.create(html_string).path
          end
        end
      end
    end
  end
end
