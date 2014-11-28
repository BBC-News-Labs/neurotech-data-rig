$: << File.join(File.dirname(__FILE__), "lib")
require 'faye'
require 'deja/application'
Faye::WebSocket.load_adapter('thin')
run Deja::Application
