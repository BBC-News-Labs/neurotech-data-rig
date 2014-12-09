module Deja
  module MessageHandlers
    class PlaybackStarted
      def initialize(args = {})
        @publisher   = args.fetch(:publisher)
        @videos_path = args.fetch(:videos_path)
      end

      def call(message)
        _, timestamp, filename = message.split(":")

        publisher.publish("/start_playback", {
          :url => video_url(filename) 
        })
      end

      def video_url(filename)
        videos_path + filename
      end

      private
        
        attr_reader :publisher, :videos_path
    end
  end
end
