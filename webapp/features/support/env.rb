require 'deja/application'
require 'capybara/cucumber'
World do
  Capybara.app = Deja::Application.new
end
