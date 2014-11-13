module Deja
  class TopicsRepository
    def initialize(args={}) 
      @videos_root = args.fetch(:videos_root)
      @filesystem = args.fetch(:filesystem)
      @topic_factory = args.fetch(:topic_factory)
      @video_factory = args.fetch(:video_factory)
    end

    def get_all
      filesystem.ls(videos_root).map { |topic_name|
        topic_factory.call(topic_name, videos(topic_name)) 
      }
    end

    private

      attr_reader :videos_root, :filesystem, :topic_factory, :video_factory

      def videos(topic_name)
        filesystem.ls(videos_root, topic_name).map { |video_name|
          video_factory.call(video_name, topic_name)   
        }
      end
  end
end
