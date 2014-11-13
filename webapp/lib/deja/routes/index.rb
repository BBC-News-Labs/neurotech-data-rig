require 'deja/routes/base'
module Deja
  module Routes
    class Index < Base
      get "/" do
        services.display_video_interactor.call do |video|
          render :index, :video_url => video.url
        end
      end
    end
  end
end
