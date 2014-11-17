module Deja
  module Interactors
    class DissimilarVideo
      def initialize(params={})
        @videos_repository = params.fetch(:videos_repository)
        @video_selector = params.fetch(:video_selector)
      end

      def call(video_url, &callback)
        video = videos_repository.call(video_url) 
        dissimilar_video = video_selector.dissimilar_to(video)
        callback.call(dissimilar_video)
      end
      
      private
        attr_reader :videos_repository, :video_selector
    end
  end
end
