class Movies::CLI

    def call
        puts "\n\n\n\n\n\n"
        puts "Hello, movie-goer."
        puts "\n\n\n\n"
        sleep(1)
        puts "Enter your zip code:"
        unval_zip = gets.strip
        zip = validate_zip(unval_zip)
        list_movies
    end


    def validate_zip(zip)
        zip
    end

    def list_movies
        puts <<-DOC
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