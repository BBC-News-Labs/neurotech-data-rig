require 'deja/routes/base'
module Deja
  module Routes
    class RelatedContent < Base
      get "/related_content" do
        render :related_content
      end
    end
  end
end
