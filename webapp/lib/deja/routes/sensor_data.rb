require 'deja/routes/base'
module Deja
  module Routes
    class SensorData < Base
      get "/sensor_data" do
        render :sensor_data
      end
    end 
  end
end
