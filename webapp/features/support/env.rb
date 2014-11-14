require 'simplecov'
require 'deja/application'
require 'capybara/cucumber'
require 'capybara/poltergeist'
ENV["DEJA_VIDEOS_ROOT"] = "/srv/deja-video"
Capybara.app = Deja::Application.new
Capybara.default_driver= :poltergeist
