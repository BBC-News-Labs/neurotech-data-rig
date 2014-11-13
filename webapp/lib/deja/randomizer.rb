module Deja
  class Randomizer
    def pick(collection)
      collection.sample
    end

    def shuffle(collection)
      collection.shuffle
    end
  end
end
