require 'sinatra/base'
require 'deja/renderer'
require 'deja/service_locator'
module Deja
  module Routes
    class Base < Sinatra::Base
      private

        def render(template, parameters={})
          Renderer.new.render(template, parameters)
        end

        def services
          @services ||= ServiceLocator.new
        end
    end
  end
end
