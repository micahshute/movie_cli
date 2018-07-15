class Theater
    extend Movies::Savable::ClassMethods
    include Movies::Savable::InstanceMethods

    @@all = []

    attr_accessor :name, :address, :url

    def initialize(name: ,address: nil, url: nil)
        @name = name
        @address = address
        @url = url
        self.save
    end

    def add_movie_from_data(data)
        movie = Movie.new
        data.each do |k,v|
            movie.send("#{k}=", v)
        end
        add_movie(movie)
    end

    def add_movie(movie)
        movie.theater = self
        movie
    end

    def display_all_movies(today: true, tomorrow: true)
        puts "#{Movie.all.select{|a| a.theater == self}}"
    end
end