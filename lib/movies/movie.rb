class Movies::Movie
    extend Movies::Savable::ClassMethods
    include Movies::Savable::InstanceMethods

    @@all = []

    def self.today
        movie_1 = self.new
        movie_1.name = "The Avengers"
        movie_1.actors = ["Roberty Downey Jr.", "Chris Evans", "Chris Pratt", "Chris Hemsworth", "Scarlett Johanssen"]
        movie_1.length = "2 hrs"
        movie_1.rating = "100"
        movie_1.summary = "Everyone dies"
        movie_1.preview_url = "www.everyonedies.com"
        movie_1.show_times = {"theater1" => "5:30am", "theater2" => "4:30am"}
        movie_1.theaters = ["theater1", "theater2"]
        movie_1.genre = "Documentary"
        movie_1.buy_url = "www.buyticketheresorealpromise.com"
        movie_2 = self.new
        movie_2.name = "Star Wars"
        movie_2.actors = ["Harrison Ford", "Luke Skywalker is a lil bitch", "Darth Vader"]
        movie_2.length = "2 hrs"
        movie_2.rating = "101"
        movie_2.summary = "Han should have been a Jedi and luke his pet jawa"
        movie_2.preview_url = "www.soloisbetterthanskywalker.com"
        movie_2.show_times = {"theater1" => "6:30am", "theater2" => "7:30am"}
        movie_2.theaters = ["theater1", "theater2"]
        movie_2.genre = "Dramatic Comedy"
        movie_2.buy_url = "www.buyticketheresorealpromisehahaoopsimeanseriously.com"
        [movie_1, movie_2]
    end

    def self.tomorrow
        movie_1 = self.new
        movie_1.name = "The Avengers Tomorrow"
        movie_1.actors = ["Roberty Downey Jr.", "Chris Evans", "Chris Pratt", "Chris Hemsworth", "Scarlett Johanssen"]
        movie_1.length = "2 hrs"
        movie_1.rating = "100"
        movie_1.summary = "Everyone dies"
        movie_1.preview_url = "www.everyonedies.com"
        movie_1.show_times = {"theater1" => "5:30am", "theater2" => "4:30am"}
        movie_1.theaters = ["theater1", "theater2"]
        movie_1.genre = "Documentary"
        movie_1.buy_url = "www.buyticketheresorealpromise.com"
        movie_2 = self.new
        movie_2.name = "Star Wars Tomorrow"
        movie_2.actors = ["Harrison Ford", "Luke Skywalker is a lil bitch", "Darth Vader"]
        movie_2.length = "2 hrs"
        movie_2.rating = "101"
        movie_2.summary = "Han should have been a Jedi and luke his pet jawa"
        movie_2.preview_url = "www.soloisbetterthanskywalker.com"
        movie_2.show_times = {"theater1" => "6:30am", "theater2" => "7:30am"}
        movie_2.theaters = ["theater1", "theater2"]
        movie_2.genre = "Dramatic Comedy"
        movie_2.buy_url = "www.buyticketheresorealpromisehahaoopsimeanseriously.com"
        [movie_1, movie_2]
    end

    def self.overview
        
    end

    def self.in_theaters
        self.all.select{|m| m.is_playing}
    end

    def self.opening
        self.all.select{|m| !m.is_playing}
    end

    def self.create_or_update_from_data(data)
        found = self.find_by_name(data[:name])
        movie = found ? found : self.new
        data.each do |k,v|
            movie.send("#{k}=", v)
        end
        movie
    end

    
    #note: show_time must be a hash of theater => time
    #buy_url must be a hash of theater => time => url
    attr_accessor :name, :rating, :actors, :length, :rating, :summary, :preview_url, :show_times, :theaters, :genre, :url, :id, :is_playing, :content_rating

    def initialize(name: nil)
        @name = name
        @theaters = []
        @show_times = []
        @actors = []
        @buy_url = []
        self.save
    end

    def update_data(data)
        data.each do |k,v|
            self.send("#{k}=", v)
        end
    end


end