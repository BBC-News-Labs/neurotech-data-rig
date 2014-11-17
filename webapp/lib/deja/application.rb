require 'sinatra/base'
require 'deja/routes/index'
require 'deja/routes/videos'

module Deja
  class Application < Sinatra::Base
    use Routes::Index
    use Routes::Videos
    set :static, true
    set :public_dir, File.join(File.dirname(__FILE__), "..", "..", "public")
  end
end
