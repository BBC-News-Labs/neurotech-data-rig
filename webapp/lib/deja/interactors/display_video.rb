module Deja
  module Interactors
    class DisplayVideo
      def initialize(args={})
        @selector = args.fetch(:video_selector)
      end

      def call(&callback)
        video = selector.start_session
        callback.call(video) 
      end

      private
        attr_reader :selector
    end
  end
end
