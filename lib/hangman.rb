require_relative "print_stand"



class Hangman
    def initialize
        read_words = File.readlines("5desk.txt") 
        words = []
        read_words.each do |w|
            if w.length > 4 && w.length < 13
                words << w.downcase 
            end
        end
        pick = rand(words.length)

        @loaded_game = false
        load_game_or_new_game

        if @loaded_game == false
            @wrong_guess = 0
            @word = words[pick]
            @letters = @word.split("")
            @founded_words = []
        end
        print_stand
        print_word
        game
    end

    private

    def game
        input_letter = ""
        while @wrong_guess < 6 && input_letter != "exit" && input_letter != "save"
            puts "Input letter"
            input_letter = gets.chomp
            if input_letter.match(/[a-zA-Z_]/) == false || (input_letter.length > 1 && input_letter != "exit" && input_letter != "save")
                while input_letter.match(/[a-zA-Z_]/) == false || (input_letter.length > 1 && input_letter != "exit" && input_letter != "save")
                    puts "Invalid input. Try again."
                    input_letter = gets.chomp
                end
            end
            input_letter.downcase!

            if input_letter == "exit"
                puts "Exitting without saving. Goodbye."
                next
            elsif input_letter == "save"
                puts "Exitting and saving. Goodbye."
                save_game
                next
            end

            if @letters.include?(input_letter)
                @founded_words << input_letter
            else
                @wrong_guess += 1
            end
            print_stand
            print_word
        end
    end

    def print_word
        @letters.each do |l|
            if @founded_words.include?(l)
                print l
            else
                print "_ "
            end
        end
        if 6-@wrong_guess == 1
            puts "1 guess left!"
        elsif 6-@wrong_guess == 0
            puts "Game over."
        else
            puts "#{6-@wrong_guess} guesses left."
        end
    end

    def save_game
        @@filename = Time.new
        @@filename = "savegames/" + @@filename.to_s + ".txt"
        File.open(@@filename,"w") do |file|
            file.puts @wrong_guess
            file.puts @letters.join("")
            file.puts @founded_words.join("")
        end
    end

    def load_game
        puts "Savegame name input:"
        @@filename = gets.chomp
        @@filename = "savegames/" + @@filename + ".txt"
        if File.exist?(@@filename)
            lines = File.readlines(@@filename)
            @wrong_guess = lines[0]
            @wrong_guess = @wrong_guess.to_i
            @letters = lines[1].split("")
            @founded_words = lines[2].split("")
            @loaded_game = true
        end
    end

    def load_game_or_new_game
        opt = ""
        puts "Load game? (y/n)"
        while opt != "y" && opt != "n"
            opt = gets.chomp
            opt.downcase!
        end
        if opt == "y"
            load_game
            if File.exist?(@@filename) == false
                puts "File doesn't exist. Try Again? (y/input any other character)"
                while opt == "y" && File.exist?(@@filename) == false 
                    @@filename = nil
                    opt = gets.chomp
                    opt.downcase!
                    load_game
                end
            end
        else
            puts "Starting a new game."
        end
    end
end

play = Hangman.new