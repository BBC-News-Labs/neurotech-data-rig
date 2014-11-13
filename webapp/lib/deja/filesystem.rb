module Deja
  class Filesystem
    def ls(*path)
      Dir.entries(File.join(*path)) - %w{. ..}
    end
  end
end
