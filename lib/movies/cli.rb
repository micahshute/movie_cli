class Movies::CLI

    def call
        puts "\n\n\n\n\n\n"
        puts "Hello, movie-goer."
        puts "\n\n\n\n"
        puts "Loading current movies..."
        @scraper = Movies::Scraper.new
        puts "\n\n"
        # get_zip
        populate_general_movies
        main_menu
    end

    def get_zip
        puts "Enter your zip code:"
        unval_zip = gets.strip
        puts "\n"
        zip = validate_zip(unval_zip)
    end

    def main_menu
        kill = false
        while !kill
            list_movies
            puts "\n ==>  Select a movie by entering it's number"
            puts "\n -->  Type 'more' for more options"
            puts "\n -->  Type 'theaters' to view local theaters"
            # puts "\n Type 'movies' to list all locally showing movies"
            # puts "\n Type 'tomorrow' to see tomorrow's movie times, and 'today' to see today's"
            puts "\n ==> Type 'exit' to kill this program\n"
            input = gets.strip.downcase
            case input
            when "exit"
                kill = true
            when 'local theaters'
                puts 'To the theaters menu'
                zip = validate_zip(gets.strip)
                @scraper.parse_local_theater_times(zip)
            when 'movies'
                puts 'To movie details'
            when 'more'
                puts 'Showing more movie options'
            else
                #Test for a number, if not, error
                if input.to_i == 0
                    "Sorry, you must enter a valid input"
                else
                    puts "Retrieving your movie data..."
                    movie = index_to_object(input.to_i, Movies::Movie.opening, Movies::Movie.in_theaters)
                    if !movie.nil?
                        movie.update_data(@scraper.parse_movie_data(movie))
                        display_movie_details(movie)
                    end

                end
            end
        end
    end


    def display_movie_details(movie)
        puts "\n\n\n"
        puts "#{movie.name} \n\n"
        puts "Genre: ".colorize(:light_blue) + "#{movie.genre}   " + "Content Rating: ".colorize(:light_blue) + "#{movie.content_rating}   " + "Length: ".colorize(:light_blue) + "#{movie.length}"
        puts "Starring: ".colorize(:light_blue) + "#{movie.actors}"
        puts "Fan Rating: ".colorize(:light_blue) + "#{movie.rating} / 5"
        puts "\n"

        puts movie.summary == "" ? "There is no summary for this movie" : "Summary: \n".colorize(:light_blue) + "#{movie.summary}"
        puts "\n\n"
        puts "Watch Trailer: ".colorize(:light_blue) + "#{movie.preview_url}" if !movie.preview_url.nil?
        puts "\n\n"
        puts "Press 'Enter' to return to the main menu"
        gets
    end


    def validate_zip(zip)
        zip
    end

    def populate_general_movies
        movies_data = @scraper.parse_movie_overview
        movies_data.each do |data|
            movie = Movies::Movie.new
            data.each do |k,v|
                movie.send("#{k}=",v)
            end
        end
    end

    def list_movies
        puts "OPENING THIS WEEK: \n".colorize(:blue)
        opening_number = 0
        Movies::Movie.opening.each.with_index do |m, i|
            print "#{i + 1}. "
            display_general(m)
            opening_number = i + 1
        end

        puts "\n\nIN THEATERS NOW: \n".colorize(:blue)
        Movies::Movie.in_theaters.each.with_index do |m, i|
            break if i > 15
            print "#{i + opening_number + 1}. "
            display_general(m)
        end
    end

    def display_general(movie)
        print "#{movie.name} \n"
    end


    def index_to_object(index, *iters)
        ret_obj = nil
        tot_counter = 1
        iters.each do |iter|
            loc_counter = 0
            iter.each do |i|
                counter = tot_counter + loc_counter
                if counter == index
                    ret_obj = i
                    break
                end
                loc_counter += 1
            end
            tot_counter = loc_counter + 1
            break if !ret_obj.nil?
        end
        ret_obj
    end



end