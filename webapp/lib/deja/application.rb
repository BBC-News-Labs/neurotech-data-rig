require 'sinatra/base'
require 'faye'
require 'deja/routes/index'
require 'deja/routes/videos'
require 'deja/routes/related_content'

module Deja
  class Application < Sinatra::Base
    use Routes::Index
    use Routes::Videos
    use Routes::RelatedContent
    use Faye::RackAdapter, :mount => "/faye"
    set :static, true
    set :public_dir, File.join(File.dirname(__FILE__), "..", "..", "public")
  end
end
