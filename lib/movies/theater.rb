class Movies::Theater
    extend Movies::Savable::ClassMethods
    include Movies::Savable::InstanceMethods

    @@all = []

    attr_accessor :name, :address, :url, :phone, :zip_code

    def initialize(name: nil,address: nil, url: nil)
        @name = name
        @address = address
        @url = url
        self.save
    end

    def add_movie_from_data(data)
        movie = Movies::Movie.new
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
        puts "#{Movies::Movie.all.select{|a| !a.theaters[self.name].nil?}}"
    end

    def movies=(data)
        data.each{ |d| Movies::Movie.create_or_update_from_data(d) }   
    end 

    def movies
        Movies::Movie.all.select do |m|
            m.theaters.has_key?(self.name)
        end
    end
end