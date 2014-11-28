module Deja
  class MessageDispatcher
    def initialize(mapping={})
      @mapping = mapping 
    end

    def route(message)
      handler = handler_for(message)
      handler.call(message) if handler
    end

    private
      attr_reader :mapping

      def handler_for(message)
         _, handler = mapping.find { |(prefix, handler)| message.start_with?(prefix) }
         return handler
      end
  end
end
