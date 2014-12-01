module Deja
  module Services
    class Wikipedia
      class Result < Struct.new(:title, :snippet)
        def url
          base_url + path
        end

        private

        def base_url
          "http://en.wikipedia.org/wiki/"
        end

        def path
          CGI.escape(title.gsub(/\s+/, "_"))
        end
      end

      def initialize(args={})
        @http_client = args.fetch(:http_client)
        @json_parser = args.fetch(:json_parser)
      end


      def lookup_term(term, &callback) 
        http_client.get(endpoint_url, params(term)) do |response|
          json = json_parser.parse(response) 
          result = json["query"]["search"].first
          callback.call(Result.new(result["title"], result["snippet"]))
        end
      end

      private

        attr_reader :http_client, :json_parser

        def endpoint_url
          "http://en.wikipedia.org/w/api.php"
        end

        def params(term)
          {
            "format"   => "json",
            "action"   => "query",
            "list"     => "search",
            "srsearch" => term
          }
        end
    end
  end
end
