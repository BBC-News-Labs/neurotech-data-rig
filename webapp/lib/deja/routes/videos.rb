require 'deja/routes/base'

module Deja
  module Routes
    class Videos < Base
      get "/videos/similar_to" do
        services.similar_video_interactor.call(params[:video]) do |video|
          content_type :text
          video.url
        end
      end

      get "/videos/dissimilar_to" do
        services.dissimilar_video_interactor.call(params[:video]) do |video|
          content_type :text
          video.url
        end
      end
    end
  end
end
