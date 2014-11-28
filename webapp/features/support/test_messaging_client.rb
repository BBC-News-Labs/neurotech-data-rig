require 'ffi-rzmq'

class TestMessagingClient
  def initialize
    address = ENV.fetch("DEJA_SENSOR_DATA_ADDRESS")
    @context = ZMQ::Context.create(1)
    @socket = @context.socket(ZMQ::PAIR)
    @socket.setsockopt(ZMQ::LINGER, 0)
    @socket.connect(address)
  end

  def send_message(message)
    socket.send_string(message) 
  end

  def finalize
    socket.close
    context.terminate
  end

  private

    attr_reader :socket, :context
end
