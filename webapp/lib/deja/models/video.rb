module Deja
  module Models
    class Video < Struct.new(:file_name, :topic_name)
      def url
        [videos_path, topic_name, file_name].join("/")
      end

      private

      def videos_path
        "/videos"
      end
    end
  end
end
