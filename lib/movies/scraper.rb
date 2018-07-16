require 'pry'
class Movies::Scraper


    #https://www.fandango.com/napi/theaterswithshowtimes?zipCode=29403&city=&state=&date=2018-07-15&page=1&favTheaterOnly=false&limit=10&isdesktop=true
    #https://www.fandango.com/api/navigation/ecustheader?callback=jQuery21107108084135063473_1531699830904&location=29403&_=1531699830905
    attr_accessor :base_url, :zip_code
    def initialize(base_url: "https://www.fandango.com/", zip_code: nil)
        @base_url = base_url
        @zip_code = zip_code
    end

    def parse_local_theaters(zip_code = @zip_code, tomorrow=false)
        date = tomorrow ? Time.now.to_date.next_day.to_s : Time.now.to_date.to_s
        date_param = date.to_time.to_i.to_s
        # url = "https://www.fandango.com/napi/theaterswithshowtimes?zipCode=" + zip_code + "&city=&state=" + "&date=" + date + "&page=1&favTheaterOnly=false&limit=10&isdesktop=true"
        url = "https://www.fandango.com/api/navigation/ecustheader?callback=jQuery21107108084135063473_1531699830904&location=29403&_=" + date_param
        response = Nokogiri::XML(HTTParty.get(url))
        # json = JSON.parse(response)
        puts response
        # theaters = doc.css('div.tsp section.row div.fd-showtimes.js-theaterShowtimes-loading li.fd-theater')
    end

    def parse_local_theater_times(zip_code = @zip_code, tomorrow=false)
        date = tomorrow ? Time.now.to_date.next_day.to_s : Time.now.to_date.to_s
        get_cookie_url = "https://www.fandango.com/" + zip_code + "_movietimes?mode=general&q=" + zip_code
        cookie_res = HTTParty.get(get_cookie_url)
        cookie = cookie_res.headers['set-cookie']
        headers = {
            "cookie" => cookie,
            "referer" => get_cookie_url,
            "if-none-match" => 'W/"2e6f1-ev4DVJdkUntSlJ2sy3cauA"',
            "user-agent" => 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/67.0.3396.99 Safari/537.36'
        }
        url = "https://www.fandango.com/napi/theaterswithshowtimes?zipCode=" + zip_code + "&city=&state=" + "&date=" + date + "&page=1&favTheaterOnly=false&limit=10&isdesktop=true"
        res = HTTParty.get(url, headers: headers)
        json = JSON.parse(res.body)
        theaters_info = json["theaters"]
        theaters = theaters_info.map do |theater_info|
            {
                name: theater_info["name"],
                phone: theater_info["phone"],
                zip_code: theater_info['zip'],
                url: theater_info["theaterPageUrl"],
                address: theater_info["address1"] + "\n" + theater_info["address2"],
                movies: theater_info["movies"].map do |m| 
                    {
                        id: m["id"],
                        name: m['title'],
                        length: m['runtime'].to_s + " mins",
                        content_rating: m['rating'],
                        genres: m['genres'],
                        concat_theater: {
                            theater_info["name"] => m["variants"].map do |formats_info|
                                        formats_info["amenityGroups"].map do |times_cat_hash|
                                            times_cat_hash["showtimes"].map do |times_hash|
                                                times_hash["ticketingDate"]
                                            end
                                        end.flatten
                                    end.flatten
                        }
                    }
                end
            }
        end
        theaters
        # theaters = doc.css('div.tsp section.row div.fd-showtimes.js-theaterShowtimes-loading li.fd-theater')
    end


    def parse_all_movies_from_theater(theater, tomorrow=false)
    end

    def parse_movie_times(zip = @zip)
        doc = Nokogiri::HTML(HTTParty.get("https://www.fandango.com/skyscraper-2018-208910/plot-summary"))
        times = doc.css('section.movie-showtimes')
        puts times
    end

    def parse_movie_data(movie)
        url_arr = movie.url.split("/")
        url_arr[url_arr.length - 1] = "plot-summary"
        url_actors = url_arr
        url_actors[url_actors.length - 1] = "cast-and-crew"
        url_actors = url_actors.join('/')
        url = url_arr.join("/")
        doc = Nokogiri::HTML(open(url))
        links = doc.css('div.mop__details-inner li.subnav__link-item a.subnav__link')
        link = links.select{ |a| a.text == "Trailers" }
        link_prev = link.length == 0 ? nil : link[0]['href']
        info = doc.css('section.movie-details ul.movie-details__detail')
        summary= doc.css('p.movie-synopsis__body').text
        rating_length = info.css('li')[2].text
        content_rating_length = parse_rating_length(rating_length)
        content_rating = content_rating_length[0]
        length = content_rating_length[1]
        genre = info.css('li')[3].text
        rating = info.css('div.js-fd-star-rating.fd-star-rating')[0]['data-star-rating']
        stars = get_stars(url_actors)
        movie_data = {
            summary: summary,
            genre: genre,
            rating: rating,
            content_rating: content_rating,
            length: length,
            preview_url: link_prev,
            actors: stars
        }
        movie_data
    end

    def get_stars(url)
        doc = Nokogiri::HTML(open(url))
        actors = doc.css('section.cast-and-crew__wrap dt.cast-and-crew__credit-person a')
        top_3 = actors.map do |a| 
            a.text
        end
        top_3[0..4].join(", ")
    end

    def parse_rating_length(combined_string)
        parts = combined_string.strip.gsub(",","").split(" ")
        rating = parts.shift
        length = parts.join(" ")
        [rating, length]
    end


    def parse_movie_overview()
        url = @base_url + "moviesintheaters"
        doc = Nokogiri::HTML(open(url))
        all_movies = doc.css('div.browse-movies.now-playing.page div.movie-ls-group')
        opening = all_movies[0].css('ul.visual-list.movie-list div.visual-detail a.visual-title.dark')
        now_playing = all_movies[1].css('ul.visual-list.movie-list div.visual-detail a.visual-title.dark')
        opening_movies = opening.map do |a|
            {
                url: parsed_url(a.text.strip, a['href']),
                name: a.text.strip,
                is_playing: false
            }
        end
        now_playing_movies = now_playing.map do |a|
            {
                url: parsed_url(a.text.strip, a['href']),
                name: a.text.strip,
                is_playing: true
            }
        end
       opening_movies.concat(now_playing_movies)
    end

    def parsed_url(name, bad_url)
        url_parts = bad_url.split('/')
        problem_part = url_parts[3]
        name_id = problem_part.split("_")
        name_id[0] = name.downcase.gsub(" ", "-").gsub(":", "")
        fixed_portion = name_id.join("-")
        url_parts[3] = fixed_portion
        url_parts.join("/")
    end

end

