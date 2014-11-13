require 'deja/video_selector'
describe Deja::VideoSelector do
  let(:topics_repository) {
    double(:topics_repository, :get_all => topics)
  }

  let(:randomizer) { 
    double(:randomizer).tap do |randomizer|
      allow(randomizer).to receive(:pick).with(topics).and_return(topic)
      allow(randomizer).to receive(:pick).with(videos).and_return(video)
    end
  }

  let(:topics) { double(:topics) }
  let(:topic) { double(:topic, :videos => videos) }

  let(:videos) { double(:videos) }
  let(:video) { double(:video) }

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
      expect(topic).to have_received(:videos)
    end

    it "selects a random video from the topic" do
      selector.start_session
      expect(randomizer).to have_received(:pick).with(videos)
    end

    it "returns the selected video" do
      expect(selector.start_session).to eq(video)
    end
  end
end
