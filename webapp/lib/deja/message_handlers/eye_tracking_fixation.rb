module Deja
  module MessageHandlers
    class EyeTrackingFixation
      def initialize(deps={})
        @publisher = deps.fetch(:publisher)
      end

      def call(message)
        _, timestamp, duration, x, y = message.split(":") 
        publisher.publish("/eye_fixation", {
          :duration => duration.to_i,
          :x        => x.to_i,
          :y        => y.to_i
        })
      end

      private

        attr_reader :publisher
    end
  end
end
