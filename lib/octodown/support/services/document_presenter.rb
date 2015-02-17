module Octodown
  module Support
    module Services
      class DocumentPresenter
        def self.call(html_string, options)
          case options[:presenter]
          when :server
            Server.new(options).start do |s|
              Launchy.open "http://localhost:#{s.port}"
            end
          when :raw then puts html_string
          when :pdf then Launchy.open PDFFile.create(html_string).path
          else Launchy.open HTMLFile.create(html_string).path
          end
        end
      end
    end
  end
end
