require 'spec_helper'
require 'deja/services/youtube_search'
describe Deja::Services::YouTubeSearch do

  let(:http_client) {
    double(:http_client).tap do |http_client|
      allow(http_client).to receive(:get).and_yield(json)
    end
  }

  let(:json_parser) {
    double(:json_parser).tap do |json_parser|
      allow(json_parser).to receive(:parse).and_return(parsed_json)
    end 
  }

  let(:json) {
    double(:json) 
  }

  let(:parsed_json) {
    {
      "feed"=> {
        "entry"=> [
          {
            "id" => {
              "$t"=> "tag:youtube.com,2008:video:abcdef12345" 
            }
          }
        ]
      }
    }
  }

  let(:term) {
    double(:term) 
  }

  subject(:service)  {
    Deja::Services::YouTubeSearch.new(
      :http_client => http_client,
      :json_parser => json_parser 
    ) 
  } 
  
  describe "#lookup_term" do
    it "looks up the term against the youtube search api" do
      service.lookup_term(term) do
      end

      expect(http_client).to have_received(:get).with("http://gdata.youtube.com/feeds/api/videos", {
        "v"   => "2",
        "q"   => term,
        "alt" => "json"
      })
    end

    it "parses the resulting json" do
      service.lookup_term(term) do
      end
      
      expect(json_parser).to have_received(:parse).with(json)
    end

    it "constructs and yields the embed url of the first result" do
      expect { |b| service.lookup_term(term, &b) }.to yield_with_args("http://www.youtube.com/embed/abcdef12345");
    end
  end
end
