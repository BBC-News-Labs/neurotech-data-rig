require 'spec_helper'
require 'deja/models/video'
describe Deja::Models::Video do
  let(:video_name) { "Some video file.mp4" }
  let(:topic_name) { "Some topic name"}
  subject(:video) do
    Deja::Models::Video.new(video_name, topic_name)
  end

  describe "#url" do
    it "prepends /videos to the filename" do
      expect(video.url).to eq("/videos/Some topic name/Some video file.mp4")
    end
  end
end
