# frozen_string_literal: true

module Octodown
  module Renderer
    module Renderable
      def self.included(base)
        base.extend ClassMethods
      end

      module ClassMethods
        def render(*args)
          new(*args).content
        end
      end
    end
  end
end
