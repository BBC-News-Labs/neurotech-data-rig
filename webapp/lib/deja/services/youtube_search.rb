module Deja
  module Services
    class YouTubeSearch
      def initialize(args={})
        @http_client = args.fetch(:http_client)
        @json_parser = args.fetch(:json_parser)
      end

      def lookup_term(term, &callback)
        http_client.get(endpoint_url, params(term)) do |response|
          json = json_parser.parse(response)
          id_string = json["feed"]["entry"].first["id"]["$t"]
          url = embed_url(parse_id(id_string))
          callback.call(url)
        end 
      end

      private

        attr_reader :http_client, :json_parser

        def endpoint_url
          "http://gdata.youtube.com/feeds/api/videos"
        end

        def params(term)
          {
            "q"   => term,
            "v"   => "2",
            "alt" => "json"
          }
        end
        
        def parse_id(id_string)
          Hash[id_string.split(":").each_slice(2).to_a]["video"]
        end

        def embed_url(id)
          "http://www.youtube.com/embed/#{id}"
        end
    end
  end
end
