require 'sinatra/base'
require 'deja/routes/index'

module Deja
  class Application < Sinatra::Base
    use Routes::Index
  end
end
