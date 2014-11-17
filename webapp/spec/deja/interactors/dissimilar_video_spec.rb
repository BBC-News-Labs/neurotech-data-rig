require 'spec_helper'
require 'deja/interactors/dissimilar_video'

describe Deja::Interactors::DissimilarVideo do
  let(:video_selector) {
    double(:video_selector, :dissimilar_to => dissimilar_video) 
  }

  let(:videos_repository) {
    double(:videos_repository, :call => video)
  }

  let(:video_url) {
    double(:video_url) 
  }

  let(:video) {
    double(:video) 
  }

  let(:dissimilar_video) {
    double(:dissimilar_video) 
  }

  subject(:interactor) {
    Deja::Interactors::DissimilarVideo.new(
      :video_selector   => video_selector,
      :videos_repository => videos_repository,
    ) 
  }

  it "creates a video object from the passed url" do
    interactor.call(video_url) do
    end
    expect(videos_repository).to have_received(:call).with(video_url)
  end

  it "gets a new video from the selector dissimilar to the passed video" do
    interactor.call(video_url) do
    end
    expect(video_selector).to have_received(:dissimilar_to).with(video)
  end

  it "yields the dissimilar video to the callback" do
    expect {|b| interactor.call(video_url, &b) }.to yield_with_args(dissimilar_video)
  end
end
