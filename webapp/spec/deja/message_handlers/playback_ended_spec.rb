require 'spec_helper'
require 'deja/message_handlers/playback_ended'
describe Deja::MessageHandlers::PlaybackEnded do

  let(:publisher) {
    double(:publisher).tap do |publisher|
      allow(publisher).to receive(:publish)
    end
  }
  let(:wikipedia_service) {
    double(:wikipedia_service).tap do |wikipedia_service|
      allow(wikipedia_service).to receive(:lookup_term).and_yield(wikipedia_response)
    end
  }

  let(:wikipedia_title) {
    double(:wikipedia_title) 
  }

  let(:wikipedia_url) {
    double(:wikipedia_url) 
  }
  
  let(:wikipedia_snippet) {
    double(:wikipedia_snippet) 
  }

  let(:wikipedia_response) {
    double(:wikipedia_response, {
      :title   => wikipedia_title,
      :snippet => wikipedia_snippet,
      :url     => wikipedia_url,
    })  
  }

  let(:tag) {
    "The Moon Landings"  
  }

  let(:rank) {
    0 
  }

  let(:message) {
    "videoPlaybackEnded:moon_landings.mp4:1969:History:#{tag}:#{rank}" 
  }

  let(:images_service) {
    double(:images_service).tap do |images_service|
      allow(images_service).to receive(:lookup_term).and_yield(image_url)
    end
  }

  let(:image_url) {
    double(:image_url) 
  }

  let(:videos_service) {
    double(:videos_service).tap do |videos_service|
      allow(videos_service).to receive(:lookup_term).and_yield(video_url)
    end
  }

  let(:video_url) {
    double(:video_url) 
  }

  subject(:handler) {
    Deja::MessageHandlers::PlaybackEnded.new({
      :publisher         => publisher,
      :wikipedia_service => wikipedia_service,
      :images_service    => images_service,
      :videos_service    => videos_service,
    }) 
  }

  describe "#call" do
    it "calls the wikipedia service with the tag from the message" do
      handler.call(message)
      expect(wikipedia_service).to have_received(:lookup_term).with(tag)
    end

    it "responds on the /wikilink channel, with the wikipedia page's title and url" do
      handler.call(message)
      expect(publisher).to have_received(:publish).with("/wikilink", {
        :title   => wikipedia_title,
        :snippet => wikipedia_snippet,
        :url     => wikipedia_url
      })
    end
    
    context "when the rank is 0" do
      it "requests 3 images for the given tag from the image service" do
        handler.call(message)
        expect(images_service).to have_received(:lookup_term).with(tag, 3)
      end
    end

    context "when the rank is > 0" do
      let(:rank) { 1 }

      it "requests 1 image for the given tag from the image service" do
        handler.call(message)
        expect(images_service).to have_received(:lookup_term).with(tag, 1)
      end
    end

    it "responds on the /image channel with the image's url" do
      handler.call(message)
      expect(publisher).to have_received(:publish).with("/image", {
        :url => image_url
      })
    end

    it "calls the videos service with the tag from the message" do
      handler.call(message)
      expect(videos_service).to have_received(:lookup_term).with(tag)
    end

    it "responds on the /video channel with the video embed url" do
      handler.call(message)
      expect(publisher).to have_received(:publish).with("/video", {
        :url => video_url
      })
    end
  end
end
