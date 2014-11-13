require 'mustache'

module Deja
  class Renderer
    def render(name, parameters={})
      view = Mustache.render(template(name),parameters) 
      Mustache.render(template(layout_name), :content => view)
    end

    private

    def template(name)
      File.read(File.join(views_directory, "#{name}.mustache"))
    end

    def views_directory
      File.join(File.dirname(__FILE__), "..", "..", "views")
    end
    
    def layout_name
      "layout"
    end
  end
end
