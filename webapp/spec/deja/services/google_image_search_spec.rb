require 'spec_helper'
require 'deja/services/google_image_search'
describe Deja::Services::GoogleImageSearch do

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
      "responseData" => {
        "results" => [
          {
            "url" => "http://example.com/ronnies.jpg"
          }, 
          {
            "url" => "http://example.com/ronnies_2.jpg"
          },
          {
            "url" => "http://example.com/ronnies_3.jpg"
          },
        ]
      }
    }
  }

  let(:term) {
    double(:term) 
  }

  subject(:service)  {
    Deja::Services::GoogleImageSearch.new(
      :http_client => http_client,
      :json_parser => json_parser 
    ) 
  } 

  describe "#lookup_term" do
    it "looks up the term against the google ajaxsearch api" do
      service.lookup_term(term) do
      end

      expect(http_client).to have_received(:get).with("http://ajax.googleapis.com/ajax/services/search/images", {
        "v" => "1.0",
        "q" => term
      })
    end

    it "parses the resulting json" do
      service.lookup_term(term) do
      end
      
      expect(json_parser).to have_received(:parse).with(json)
    end

    it "yields the url of the first result" do
      expect { |b| service.lookup_term(term, &b) }.to yield_with_args("http://example.com/ronnies.jpg");
    end

    context "when a specific number of images is provided" do
      it "yields the correct number of images" do
        expect { |b| service.lookup_term(term, 3, &b) }.to yield_successive_args(
          "http://example.com/ronnies.jpg",
          "http://example.com/ronnies_2.jpg",
          "http://example.com/ronnies_3.jpg",
        ) 
      end
    end
  end
end
