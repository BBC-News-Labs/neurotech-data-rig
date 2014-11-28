require 'simplecov'
require 'deja/broker'
require 'deja/application'
require 'capybara/cucumber'
require 'capybara/poltergeist'
require 'faye'
require 'rack/handler/thin'

PORT = 12345

ENV["DEJA_VIDEOS_ROOT"] = "/srv/deja-video"
ENV["DEJA_SENSOR_DATA_ADDRESS"] = "tcp://0.0.0.0:2122"
ENV["DEJA_FAYE_SERVER_URL"] = "http://localhost:#{PORT}/faye"

Capybara.app = Deja::Application.new 
Capybara.server_port = PORT
Capybara.server do |app, port|
  Rack::Handler::Thin.run(app, :Port => port)
end
Capybara.default_driver = :poltergeist
Faye::WebSocket.load_adapter('thin')

pid = Process.pid
SimpleCov.at_exit do
  SimpleCov.result.format! if Process.pid == pid
end

broker_pid = fork do
  broker = Deja::Broker.new(:persist_faye_connection => false)
  broker.start
end

at_exit do
  Process.kill("INT", broker_pid)
end
