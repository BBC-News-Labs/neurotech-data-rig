require 'eventmachine'
require 'em-zeromq'
require 'ffi-rzmq'
require 'faye'
require 'json'
require 'deja/message_dispatcher'
require 'deja/message_handlers/playback_ended'
require 'deja/services/wikipedia'
require 'deja/async_http_client'

module Deja
  class Broker
    def start
      at_exit do
        zmq_socket.close
        zmq_context.terminate
      end
      EM.run do
        zmq_socket.on(:message) do |message|
          text = message.copy_out_string
          dispatcher.route(text)
          message.close
        end
      end
    end

    private

    def zmq_context
      @context ||= EM::ZeroMQ::Context.new(zmq_thread_pool_size)
    end

    def zmq_socket
      @socket ||= zmq_context.socket(ZMQ::PAIR).tap do |socket|
        socket.bind(zmq_socket_address)
      end
    end

    def zmq_socket_address
      ENV.fetch("DEJA_SENSOR_DATA_ADDRESS")
    end

    def zmq_topic
      ""
    end

    def zmq_thread_pool_size
      1
    end

    def faye_client
      @faye_client ||= Faye::Client.new(faye_client_url)
    end

    def faye_client_url
      ENV.fetch("DEJA_FAYE_SERVER_URL")
    end

    def dispatcher
      Deja::MessageDispatcher.new({
        "videoPlaybackEnded"  => playback_ended_handler,
      });
    end

    def playback_ended_handler
      Deja::MessageHandlers::PlaybackEnded.new(
        :publisher => faye_client,
        :wikipedia_service => wikipedia_service,
      )
    end

    def wikipedia_service
      Deja::Services::Wikipedia.new(
        :http_client => http_client,
        :json_parser => json_parser
      )
    end

    def http_client
      Deja::AsyncHTTPClient.new
    end

    def json_parser
      JSON
    end
  end
end
