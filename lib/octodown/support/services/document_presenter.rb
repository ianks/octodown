module Octodown
  module Support
    module Services
      class DocumentPresenter
        def self.call(html_string, options)
          case options[:presenter]
          when :raw
            puts html_string
          when :server
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
