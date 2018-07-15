class Movies::Scraper

    attr_accessor :base_url, :zip_code
    def initialize(base_url="https://www.fandango.com/", zip_code, date=Time.now)
        @base_url = base_url
        @zip_code = zip_code
    end

    def parse_all_movies(zip_code, date)
    end

    def parse_all_movies_from_theater(theater)

end