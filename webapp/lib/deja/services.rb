require 'deja/interactors/display_video'
require 'deja/interactors/similar_video'
require 'deja/interactors/dissimilar_video'
require 'deja/video_selector'
require 'deja/randomizer'
require 'deja/filesystem'
require 'deja/topics_repository'
require 'deja/models/topic'
require 'deja/models/video'

module Deja
  class Services 
    def display_video_interactor
      Interactors::DisplayVideo.new(:video_selector => video_selector)
    end 

    def similar_video_interactor
      Interactors::SimilarVideo.new(
        :video_selector    => video_selector,
        :videos_repository => videos_repository,
      )
    end

    def dissimilar_video_interactor
      Interactors::DissimilarVideo.new(
        :video_selector    => video_selector,
        :videos_repository => videos_repository,
      )
    end

    private

    def video_selector
      VideoSelector.new(
        :topics_repository => topics_repository,
        :randomizer        => randomizer
      )
    end

    def topics_repository
      TopicsRepository.new(
        :videos_root   => videos_root,
        :filesystem    => filesystem,
        :topic_factory => topic_factory,
        :video_factory => video_factory,
      )
    end

    def randomizer
      Randomizer.new
    end

    def filesystem
      Filesystem.new
    end

    def topic_factory
      Models::Topic.method(:new)
    end 

    def video_factory
      Models::Video.method(:new)
    end

    def videos_repository
      Models::Video.method(:from_url)
    end

    def videos_root
      ENV.fetch("DEJA_VIDEOS_ROOT")
    end
  end
end
