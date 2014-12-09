require 'spec_helper'
require 'deja/message_handlers/playback_started'
describe Deja::MessageHandlers::PlaybackStarted do
  let(:publisher) {
    double(:publisher).tap do |publisher|
      allow(publisher).to receive(:publish)
    end
  }

  let(:videos_path) {
    "/videos/" 
  }

  let(:message) {
    "videoPlaybackStarted:1418123530:1980_2Ronnies.mp4" 
  }

  subject(:handler) {
    Deja::MessageHandlers::PlaybackStarted.new({
      :publisher => publisher,
      :videos_path => videos_path,  
    }) 
  }
  
  describe "#call" do
    it "responds on the /start_playback channel, with the url for the given video" do
      handler.call(message)
      expect(publisher).to have_received(:publish).with("/start_playback", {
        :url => "/videos/1980_2Ronnies.mp4" 
      })
    end
  end
end
