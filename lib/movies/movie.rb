class Movies::Movie
    extend Movies::Savable::ClassMethods
    include Movies::Savable::InstanceMethods

    @@all = []

    def self.today

    end

    def self.tomorrow
    end

end