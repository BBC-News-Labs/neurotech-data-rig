module Deja
  class VideoSelector
    def initialize(args={})
      @topics_repository = args.fetch(:topics_repository)
      @randomizer = args.fetch(:randomizer)
    end
   
    def start_session
      pick_video(all_topics)
    end

    def similar_to(video)
      videos = topic_for(video).videos - [video]
      randomizer.pick(videos)
    end

    def dissimilar_to(video)
      pick_video(all_topics - [topic_for(video)])
    end

    private

      attr_reader :topics_repository, :randomizer
      
      def all_topics
        topics_repository.get_all
      end

      def topic_for(video)
        topics_repository.get(video.topic_name)
      end

      def pick_video(topics)
        topic = randomizer.pick(topics)
        randomizer.pick(topic.videos)
      end
  end
end
