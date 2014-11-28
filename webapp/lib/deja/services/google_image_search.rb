module Deja
  module Services
    class GoogleImageSearch
      def initialize(args={})
        @http_client = args.fetch(:http_client)
        @json_parser = args.fetch(:json_parser)
      end
      
      def lookup_term(term, &callback) 
        http_client.get(endpoint_url, params(term)) do |response|
          json = json_parser.parse(response) 
          url = json["responseData"]["results"].first["url"]
          callback.call(url)
        end
      end

      private

        attr_reader :http_client, :json_parser

        def endpoint_url
          "http://ajax.googleapis.com/ajax/services/search/images"
        end

        def params(term)
          {
            "v" => "1.0",
            "q" => term
          }
        end
    end
  end
end
