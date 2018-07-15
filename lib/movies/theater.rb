class Theater
    extend Movies::Savable::ClassMethods
    include Movies::Savable::InstanceMethods

    @@all = []

    attr_accessor :name, :address, :movies

    def initialize(name: ,address: nil, movies: [])
        @name = name
        @address = address
        @movies = movies
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
end