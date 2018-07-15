class Movies::CLI

    def call
        puts "\n\n\n\n\n\n"
        puts "Hello, movie-goer."
        puts "\n\n\n\n"
        sleep(0.1)
        get_zip
        list_movies
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
            puts "\n Select a movie by entering it's number"
            puts "\n type 'more' for more options"
            puts "\n Type 'theaters' to view local theaters"
            puts "\n Type 'movies' to list all locally showing movies"
            # puts "\n Type 'tomorrow' to see tomorrow's movie times, and 'today' to see today's"
            puts "\n Type 'exit' to kill this program\n"
            input = gets.strip.downcase
            case input
            when "exit"
                kill = true
            when 'theaters'
                puts 'To the theaters menu'
            when 'movies'
                puts 'To movie details'
            when 'more'
                puts 'Showing more movie options'
            else
                #Test for a number, if not, error
                if input.to_i == 0
                    "Sorry, you must enter a valid input"
                else
                    puts "Taking you to movie #{input}"
                end
            end
        end
    end


    def validate_zip(zip)
        zip
    end

    def list_movies
        puts <<-DOC.gsub /^\s*/, ''
            1. The Fugitive
                In this movie, Harrison Ford is a super badass

            2. Indiana Jones and the Raiders of the Lost Ark
                In this movie, Harrison Ford is a badass

            3. Star Wars Episode V: The Empire Strikes Back
                In this movie, Harrison Ford is kind of a badass

            4. It's a Wonderful Life
                In this movie, Jimmy Stewart is not a badass but it's still good
        DOC
    end

end