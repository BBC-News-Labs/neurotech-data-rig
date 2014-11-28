module Deja
  module MessageHandlers
    class PlaybackEnded
      def initialize(args={})
        @wikipedia_service = args.fetch(:wikipedia_service)
        @publisher = args.fetch(:publisher)
      end

      def call(message)
        _, file_name, year, genre, tag = message.split(":")
        wikipedia_service.lookup_term(tag) do |result|
          publisher.publish(channel_name, {
            :title   => result.title,
            :snippet => result.snippet,
            :url     => result.url
          })
        end
      end

      private

        attr_reader :wikipedia_service, :publisher

        def channel_name
          "/wikilink"
        end
    end
  end
end
