require 'spec_helper'
require 'deja/models/video'
describe Deja::Models::Video do
  let(:video_name) { "Some video file.mp4" }
  let(:topic_name) { "Some topic name"}
  subject(:video) do
    Deja::Models::Video.new(video_name, topic_name)
  end

  describe ".from_url" do
    let(:url) { "/videos/topic_name/file_name.mp4" }

    it "parses out the video filename" do
      expect(Deja::Models::Video.from_url(url).file_name).to eq("file_name.mp4")
    end

    it "parses out the video topic name" do
      expect(Deja::Models::Video.from_url(url).topic_name).to eq("topic_name")
    end
  end

  describe "#url" do
    it "prepends /video to the filename" do
      expect(video.url).to eq("/video/Some topic name/Some video file.mp4")
    end
  end
end
