require 'sinatra/base'
require 'deja/routes/index'

module Deja
  class Application < Sinatra::Base
    use Routes::Index
    set :static, true
    set :public_dir, File.join(File.dirname(__FILE__), "..", "..", "public")
  end
end
