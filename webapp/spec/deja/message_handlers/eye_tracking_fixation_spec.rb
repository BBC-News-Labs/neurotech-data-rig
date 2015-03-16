require 'spec_helper'
require 'deja/message_handlers/eye_tracking_fixation'
describe Deja::MessageHandlers::EyeTrackingFixation do
  let(:publisher) {
    double(:publisher).tap do |publisher|
      allow(publisher).to receive(:publish)
    end
  }

  let(:message) {
    "eyeTrackingFixation:1417123530:10:100:200" 
  }

  subject(:handler) {
    Deja::MessageHandlers::EyeTrackingFixation.new(
      :publisher => publisher 
    ) 
  }

  describe "#call" do
    it "responds on the /eye_fixation channel, with the position and duration of the fixation" do
      handler.call(message)
      expect(publisher).to have_received(:publish).with("/eye_fixation", {
        :duration => 10,
        :x        => 100,
        :y        => 200,
      })
    end
  end
end
