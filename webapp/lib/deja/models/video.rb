module Deja
  module Models
    class Video < Struct.new(:file_name, :topic_name)
      
      class << self
        def from_url(url)
          _, _, topic_name, file_name = url.split("/")
          new(file_name, topic_name)
        end
      end

      def url
        [videos_path, topic_name, file_name].join("/")
      end

      private

      def videos_path
        "/video"
      end
    end
  end
end
