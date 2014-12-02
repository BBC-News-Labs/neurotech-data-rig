require 'eventmachine'
require 'em-zeromq'
require 'ffi-rzmq'
require 'faye'
require 'json'
require 'deja/message_dispatcher'
require 'deja/message_handlers/playback_ended'
require 'deja/services/wikipedia'
require 'deja/services/google_image_search'
require 'deja/services/youtube_search'
require 'deja/async_http_client'

module Deja
  class Broker

    def initialize(opts={})
      @opts = defaults.merge(opts)
    end

    def start
      trap(:INT) { EM.stop }
      trap(:TERM){ EM.stop }
      EM.run do
        zmq_in_socket.on(:message) do |message|
          text = message.copy_out_string
          zmq_out_socket.send_string(text)
          dispatcher.route(text)
          message.close
        end
      end
    end

    private

      attr_reader :opts

      def defaults
        {:persist_faye_connection => true }
      end

      def persist_faye_connection?
        !!opts[:persist_faye_connection]
      end

      def zmq_context
        @context ||= EM::ZeroMQ::Context.new(zmq_thread_pool_size)
      end

      def zmq_in_socket
        @zmq_in_socket ||= zmq_context.socket(ZMQ::PAIR).tap do |socket|
          socket.bind(zmq_in_socket_address)
        end
      end

      def zmq_in_socket_address
        ENV.fetch("DEJA_SENSOR_DATA_ADDRESS")
      end

      def zmq_out_socket
        @zmq_out_socket ||= zmq_context.socket(ZMQ::PAIR).tap do |socket|
          socket.connect(zmq_out_socket_address)
        end
      end

      def zmq_out_socket_address
        ENV.fetch("DEJA_LOG_DATA_ADDRESS")
      end

      def zmq_thread_pool_size
        1
      end

      def faye_client
        if persist_faye_connection?
          @faye_client ||= Faye::Client.new(faye_client_url)
        else
          Faye::Client.new(faye_client_url)
        end
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
          :images_service => images_service,
          :videos_service => videos_service,
        )
      end

      def wikipedia_service
        Deja::Services::Wikipedia.new(
          :http_client => http_client,
          :json_parser => json_parser
        )
      end

      def images_service
        Deja::Services::GoogleImageSearch.new(
          :http_client => http_client,
          :json_parser => json_parser
        )
      end

      def videos_service
        Deja::Services::YouTubeSearch.new(
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
