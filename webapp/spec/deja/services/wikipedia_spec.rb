require 'spec_helper'
require 'deja/services/wikipedia'
describe Deja::Services::Wikipedia do

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
      "query" => {
        "search"  => [
           {
              "title"  => "Only Fools and Horses",
              "snippet" => "You plonker Rodney"
           } 
        ]
      }
    } 
  }

  let(:term) {
    double(:term) 
  }

  subject(:service)  {
    Deja::Services::Wikipedia.new(
      :http_client => http_client,
      :json_parser => json_parser 
    ) 
  } 

  describe "#lookup_term" do
    it "looks up the term against the wikipedia search api" do
      service.lookup_term(term) do
      end

      expect(http_client).to have_received(:get).with("http://en.wikipedia.org/w/api.php", {
        "format"   => "json",
        "action"   => "query",
        "list"     => "search",
        "srsearch" => term
      })
    end

    it "parses the resulting json" do
      service.lookup_term(term) do
      end
      
      expect(json_parser).to have_received(:parse).with(json)
    end

    it "returns the title of the first result as the result title" do
      result = nil
      service.lookup_term(term) do |r|
        result = r 
      end
      
      expect(result.title).to eq("Only Fools and Horses");
    end

    it "returns the snippet of the first result as the result snippet" do
      result = nil
      service.lookup_term(term) do |r|
        result = r 
      end
      
      expect(result.snippet).to eq("You plonker Rodney");
    end


    it "constructs the wikipedia url of the first result and yields it as the result url" do
      result = nil
      service.lookup_term(term) do |r|
        result = r 
      end
      
      expect(result.url).to eq("http://en.wikipedia.org/wiki/Only+Fools+and+Horses");
    end
  end
end
