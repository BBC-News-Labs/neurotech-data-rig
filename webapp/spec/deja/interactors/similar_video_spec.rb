require 'spec_helper'
require 'deja/interactors/similar_video'
describe Deja::Interactors::SimilarVideo do
  let(:video_selector) {
    double(:video_selector, :similar_to => similar_video) 
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

  let(:similar_video) {
    double(:similar_video) 
  }

  subject(:interactor) {
    Deja::Interactors::SimilarVideo.new(
      :video_selector   => video_selector,
      :videos_repository => videos_repository,
    ) 
  }

  it "creates a video object from the passed url" do
    interactor.call(video_url) do
    end
    expect(videos_repository).to have_received(:call).with(video_url)
  end

  it "gets a new video from the selector similar to the passed video" do
    interactor.call(video_url) do
    end
    expect(video_selector).to have_received(:similar_to).with(video)
  end

  it "yields the similar video to the callback" do
    expect {|b| interactor.call(video_url, &b) }.to yield_with_args(similar_video)
  end
end
