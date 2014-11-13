require 'deja/application'
require 'capybara/cucumber'
ENV["DEJA_VIDEOS_ROOT"] = "/srv/deja-video"
World do
  Capybara.app = Deja::Application.new
end
