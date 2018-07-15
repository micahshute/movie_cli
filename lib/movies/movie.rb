class Movies::Movie
    extend Movies::Savable::ClassMethods
    include Movies::Savable::InstanceMethods

    @@all = []

    def self.today

    end

    def self.tomorrow
        
    end
    
    #note: show_time must be a hash of theater => time
    #buy_url must be a hash of theater => time => url
    attr_accessor :name, :actors, :length, :rating, :summary, :preview_url, :show_times, :theaters, :genre, :buy_url

    def initialize(name: nil)
        @name = name
        @theaters = []
        @show_times = []
        @buy_url = []
        self.save
    end

end