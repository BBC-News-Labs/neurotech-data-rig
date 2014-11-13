module Deja
  class VideoSelector
    def initialize(args={})
      @topics_repository = args.fetch(:topics_repository)
      @randomizer = args.fetch(:randomizer)
    end
   
    def start_session
      topics = topics_repository.get_all
      topic = randomizer.pick(topics)
      randomizer.pick(topic.videos)
    end

    private

      attr_reader :topics_repository, :randomizer
  end
end
