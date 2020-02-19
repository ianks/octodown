# frozen_string_literal: true

module Octodown
  module Support
    module Services
      class DocumentPresenter
        def self.call(file, options)
          include Octodown::Renderer

          case options[:presenter]
          when :raw    then Raw
          when :html   then HTML
          when :server then Server
          end.new(GithubMarkdown.render(file, options), options).present
        end
      end
    end
  end
end
