module Deja
  module Interactors
    class SimilarVideo
      def initialize(params={})
        @videos_repository = params.fetch(:videos_repository)
        @video_selector = params.fetch(:video_selector)
      end

      def call(video_url, &callback)
        video = videos_repository.call(video_url) 
        similar_video = video_selector.similar_to(video)
        callback.call(similar_video)
      end

      private
        attr_reader :videos_repository, :video_selector
    end
  end
end
