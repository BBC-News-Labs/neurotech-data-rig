require 'em-http-request'
module Deja
  class AsyncHTTPClient
    def get(url, query, &callback)
      http = EventMachine::HttpRequest.new(url).get(:query => query)
      http.callback {
        callback.call(http.response) 
      }
    end
  end
end
