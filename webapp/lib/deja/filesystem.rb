module Deja
  class Filesystem
    def ls(*path)
      Dir.entries(File.join(*path)) - %w{. .. .DS_Store}
    end
  end
end
