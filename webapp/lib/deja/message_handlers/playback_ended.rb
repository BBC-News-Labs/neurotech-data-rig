module Deja
  module MessageHandlers
    class PlaybackEnded
      def initialize(args={})
        @wikipedia_service = args.fetch(:wikipedia_service)
        @images_service = args.fetch(:images_service)
        @videos_service = args.fetch(:videos_service)
        @publisher = args.fetch(:publisher)
      end

      def call(message)
        _, file_name, year, genre, tag = message.split(":")
        publish_wikilink(tag)
        publish_image(tag)
        publish_video(tag)
      end

      private

        attr_reader :wikipedia_service, :images_service, :videos_service, :publisher

        def publish_wikilink(tag)
          wikipedia_service.lookup_term(tag) do |result|
            publisher.publish("/wikilink", {
              :title   => result.title,
              :snippet => result.snippet,
              :url     => result.url
            })
          end
        end

        def publish_image(tag)
          images_service.lookup_term(tag) do |url|
            publisher.publish("/image", {:url => url})
          end
        end
        
        def publish_video(tag)
          videos_service.lookup_term(tag) do |url|
            publisher.publish("/video", {:url => url})
          end
        end
    end
  end
end
