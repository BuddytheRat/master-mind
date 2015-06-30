$LOAD_PATH.unshift(File.dirname(__FILE__))

class Mastermind
  require 'rubygems'
  require 'highline/import'

  require 'mastermind/board'
  require 'mastermind/player'
  require 'mastermind/computer'

  def initialize
    @alerts = Array.new

    @max_guess = 100
    @code_length = 4
    @code_base = 9
    @validate = Regexp.new("[^1-#{@code_base}]")
    @turn_count = 0

    @board = Board.new(@code_length, @max_guess)

    print """
    Welcome to Mastermind!
    The mastermind will create a #{@code_length} digit code,
    using the digits 1-#{@code_base}. The guesser will then
    have #{@max_guess} attempts to guess the code. One each attempt, you
    will retrieve a hint about your guess.

    0: Wrong number.
    1: Right number, wrong position.
    2: Right number, right position.

    Good luck! 
    [Type 1 to play as the codebreaker.]
    [Type 2 to play as the mastermind.]
    [Type 3 to play with two humans.]
    [Ctrl + C to quit.]
    """

    @guesser = Player.new("Kihara", @max_guess, @code_length)
    @mastermind = Computer.new("CompuButte3000", @max_guess, @code_length, @code_base)
    game_type = choose(['1', '2', '3'])

    if game_type.to_i == 3
      @mastermind = Player.new("BuddytheRat", @max_guess, @code_length)
    elsif game_type.to_i == 2
      @guesser, @mastermind = @mastermind, @guesser
    end


    @code = new_code

    game_loop
  end

  def choose(options)
    input = gets.chomp
    return input if options.include?(input)
    puts "Please choose one of the available options!"
    choose(options)
  end

  def code_invalid?(code)
    @validate.match(code) || code.length != @code_length
  end

  def out_of_guesses?
    @guesser.guess(@max_guess).none? { |g| g == " " }
  end

  def new_code
    puts "(#{@code_length} digits, 1-#{@code_base} only.)"
    code = @mastermind.input_secret_code
    if code_invalid?(code)
      puts "Sorry, that code isn't valid, try again!"
      code = new_code.join
    end
    code.split('').map { |s| s.to_i }
  end

  def new_guess
    guess = @guesser.input_code
    if code_invalid?(guess)
      puts "Sorry, that guess isn't valid, try again!"
      guess = new_guess.join
    end
    guess.split('').map { |s| s.to_i }
  end

  def compare_guess(guess)
    guess_data = Hash.new
    guess_data[:guess] = guess.dup
    code = @code.dup
    hint = Array.new

    guess.each_with_index do |num, i|
      if code[i] == num
        hint << 2 
        code[i] = 0
        guess[i] = 0
      end
    end

    guess.each_with_index do |num, i|
      next if num == 0
      hint << 0 if code.none? { |num2| num == num2 }
      hint << 1 if code.any? { |num2| num == num2 }
      code[code.index(num)] = 0 if hint.last > 0
    end

    guess_data[:hint] = hint.sort
    guess_data
  end

  def alert(alert)
    @alerts << alert
  end

  def display_alerts
    @alerts.each { |alert| puts alert }
    @alerts.clear
  end

  def game_loop
    game_over = false
    loop do
      system('cls')
      if @guesser.last_guess[:guess] == @code
        alert "#{@guesser.name} broke the code! Mastermind loses! (#{@turn_count} turns)"
        game_over = true
      elsif out_of_guesses?
        alert "#{@guesser.name} didn't break the code in time. Mastermind wins!"
        alert "The code was #{@code.inspect}"
        game_over = true
      else
        alert "Please enter your guess:"
      end
      
      #@board.display(@guesser.guesses)
      @board.display_line(@guesser.guess_data(@turn_count))
      display_alerts
      break if game_over

      guess = new_guess
      guess_data = compare_guess(guess)

      @guesser.think(guess_data) if @guesser.is_a? (Computer)
      alert @guesser.display_brain if @guesser.is_a? (Computer)

      @guesser.add_guess(guess_data)

      @turn_count += 1
    end
  end
end

loop do
  @game = Mastermind.new()
end