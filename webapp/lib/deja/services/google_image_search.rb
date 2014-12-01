module Deja
  module Services
    class GoogleImageSearch
      def initialize(args={})
        @number_of_images = args.fetch(:number_of_images, 1)
        @http_client = args.fetch(:http_client)
        @json_parser = args.fetch(:json_parser)
      end
      
      def lookup_term(term, &callback) 
        http_client.get(endpoint_url, params(term)) do |response|
          json = json_parser.parse(response) 
          json["responseData"]["results"][0..number_of_images-1].each do |result|
            callback.call(result["url"])
          end
        end
      end

      private

        attr_reader :http_client, :json_parser, :number_of_images

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
