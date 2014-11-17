require 'spec_helper'
require 'deja/video_selector'
describe Deja::VideoSelector do
  let(:topics_repository) {
    double(:topics_repository, :get_all => topics, :get => topic_1)
  }

  let(:randomizer) { 
    double(:randomizer).tap do |randomizer|
      allow(randomizer).to receive(:pick).with(topics).and_return(topic_1)
      allow(randomizer).to receive(:pick).with(videos).and_return(video_1)
    end
  }

  let(:topics) { [topic_1, topic_2, topic_3] }
  let(:topic_1) { double(:topic_1, :videos => videos) }
  let(:topic_2) { double(:topic_2) }
  let(:topic_3) { double(:topic_3) }

  let(:videos) { [video_1, video_2, video_3] }
  let(:video_1) { double(:video_1) }
  let(:video_2) { double(:video_2, :topic_name => topic_name) }
  let(:video_3) { double(:video_3) }

  let(:topic_name) { double(:topic_name) }

  subject(:selector) {
    Deja::VideoSelector.new(:topics_repository => topics_repository, :randomizer => randomizer )
  }
  describe "#start_session" do
    it "gets all the topics from the repo" do
      selector.start_session
      expect(topics_repository).to have_received(:get_all)
    end

    it "selects a random topic" do
      selector.start_session
      expect(randomizer).to have_received(:pick).with(topics)
    end

    it "gets all the videos for the chosen topic" do
      selector.start_session
      expect(topic_1).to have_received(:videos)
    end

    it "selects a random video from the topic" do
      selector.start_session
      expect(randomizer).to have_received(:pick).with(videos)
    end

    it "returns the selected video" do
      expect(selector.start_session).to eq(video_1)
    end
  end

  describe "#similar_to" do

    before do 
      allow(randomizer).to receive(:pick).with([video_1, video_3]).and_return(video_1)
    end

    it "gets the video's topic from the repo" do
      selector.similar_to(video_2)
      expect(topics_repository).to have_received(:get).with(topic_name)
    end

    it "gets all the videos for the topic" do
      selector.similar_to(video_2)
      expect(topic_1).to have_received(:videos)
    end

    it "selects a random video from the set of videos from the topic, not including the passed video" do
      selector.similar_to(video_2)
      expect(randomizer).to have_received(:pick).with([video_1, video_3])
    end

    it "returns the selected video" do
      expect(selector.similar_to(video_2)).to eq(video_1)
    end
  end

  describe "#dissimilar_to" do
    before do
      allow(randomizer).to receive(:pick).with([topic_2,topic_3]).and_return(topic_2)
      allow(topic_2).to receive(:videos).and_return([video_1, video_3])
      allow(randomizer).to receive(:pick).with([video_1, video_3]).and_return(video_1)
    end

    it "gets the video's topic from the repo" do
      selector.dissimilar_to(video_2)
      expect(topics_repository).to have_received(:get).with(topic_name)
    end

    it "gets all the topics from the repo" do
      selector.dissimilar_to(video_2)
      expect(topics_repository).to have_received(:get_all)
    end

    it "selects a random topic from the set of all topics, not including the passed videos topic" do
      selector.dissimilar_to(video_2)
      expect(randomizer).to have_received(:pick).with([topic_2, topic_3])
    end

    it "gets all the videos for the chosen topic" do
      selector.dissimilar_to(video_2)
      expect(topic_2).to have_received(:videos)
    end

    it "selects a random video from the selected topic" do
      selector.dissimilar_to(video_2)
      expect(randomizer).to have_received(:pick).with([video_1, video_3])
    end

    it "returns the selected video" do
      expect(selector.dissimilar_to(video_2)).to eq(video_1)
    end
  end
end
