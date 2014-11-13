require 'sinatra/base'
require 'deja/renderer'
require 'deja/services'
module Deja
  module Routes
    class Base < Sinatra::Base
      private

        def render(template, parameters={})
          Renderer.new.render(template, parameters)
        end

        def services
          @services ||= Services.new
        end
    end
  end
end
