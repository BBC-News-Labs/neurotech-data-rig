require 'zmq'

class TestMessagingClient
  def initialize
    address = ENV.fetch("DEJA_SENSOR_DATA_ADDRESS")
    context = ZMQ::Context.new
    @socket = context.socket(ZMQ::PAIR)
    @socket.connect(address)
  end

  def send(message)
    socket.send(message) 
  end

  private

    attr_reader :socket
end
