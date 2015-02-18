module Octodown
  module Support
    module Services
      class DocumentPresenter
        def self.call(content, options)
          case options[:presenter]
          when :server
            Server.new(options).start do |s|
              Launchy.open "http://localhost:#{s.port}"
            end
          when :raw
            puts content
          when :pdf
            Launchy.open PersistentTempfile.create(content, '.pdf').path
          else
            Launchy.open PersistentTempfile.create(content).path
          end
        end
      end
    end
  end
end
