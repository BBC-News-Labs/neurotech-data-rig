require 'spec_helper'
require "deja/interactors/display_video"
describe Deja::Interactors::DisplayVideo do
  let(:video_selector) {
    double(:video_selector, :start_session => video)
  }

  let(:video) {
    double(:video)  
  }

  subject(:interactor) {
    Deja::Interactors::DisplayVideo.new(:video_selector => video_selector) 
  }

  it "requests a starting video from the selector" do
    interactor.call do 
    end

    expect(video_selector).to have_received(:start_session)
  end

  it "yields the video to the callback" do
    expect { |b| interactor.call(&b) }.to yield_with_args(video)
  end
end
