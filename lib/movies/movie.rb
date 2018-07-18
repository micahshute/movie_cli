class Movies::Movie
    extend Movies::Savable::ClassMethods
    include Movies::Savable::InstanceMethods

    @@all = []

    def self.in_theaters
        self.all.select{|m| m.is_playing}
    end

    def self.opening
        self.all.select{|m| !m.is_playing}
    end
    
    #note: theaters must be a hash of theater => [time]
    #buy_url must be a hash of theater => time => url
    attr_accessor :name, :id, :rating, :actors, :length, :rating, :summary, :preview_url, :theaters, :genres, :url, :id, :is_playing, :content_rating

    def initialize(name: nil)
        @name = name
        @theaters = {}
        @show_times = []
        @actors = []
        @buy_url = []
        self.save
    end

    def update_data(data)
        data.each do |k,v|
            self.send("#{k}=", v)
        end
        self
    end

    def concat_theater=(theater_hash)
        theater_hash.each do |theater, times|
            if @theaters[theater].nil?
                formatted_times = times.map{|t| t.gsub("+", " @ ")}
                @theaters[theater] = formatted_times
            else
                times.each do |t|
                    time = t.gsub("+", " @ ")
                    if !@theaters[theater].include?(time)
                        @theaters[theater].push(time)
                    end
                end
            end
        end
    end


end