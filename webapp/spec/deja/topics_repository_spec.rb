require 'deja/topics_repository'
describe Deja::TopicsRepository do

  let(:videos_root) { double(:videos_root) } 
  let(:filesystem) { 
    double(:filesystem).tap do |filesystem|
      allow(filesystem).to receive(:ls).with(videos_root).and_return([topic_name])
      allow(filesystem).to receive(:ls).with(videos_root, topic_name).and_return([video_name])
    end
  }

  let(:topic_name) { double(:topic_name) }
  let(:video_name) { double(:video_name) }

  let(:topic) { double(:topic) }
  let(:video) { double(:video) }
  
  let(:topic_factory) { double(:topic_factory, :call => topic) }
  let(:video_factory) { double(:video_factory, :call => video) }

  subject(:repository) {
    Deja::TopicsRepository.new(
      :videos_root   => videos_root,
      :filesystem    => filesystem,
      :topic_factory => topic_factory,
      :video_factory => video_factory
    ) 
  }

  describe "#get_all" do
    it "lists the topics available in the videos root directory" do
      repository.get_all
      expect(filesystem).to have_received(:ls).with(videos_root)
    end

    it "gets the list of videos available for each topic" do
      repository.get_all
      expect(filesystem).to have_received(:ls).with(videos_root, topic_name)
    end

    it "builds a video for each video file" do
      repository.get_all
      expect(video_factory).to have_received(:call).with(video_name, topic_name)
    end

    it "builds a topic for each topic name and set of videos" do
      repository.get_all
      expect(topic_factory).to have_received(:call).with(topic_name, [video])
    end

    it "returns the topics" do
      expect(repository.get_all).to eq([topic])
    end
  end
end
