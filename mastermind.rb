$LOAD_PATH.unshift(File.dirname(__FILE__))

class Mastermind
  require 'rubygems'
  require 'highline/import'

  require 'mastermind/board'
  require 'mastermind/player'
  require 'mastermind/computer'

  def initialize
    @alerts = Array.new

    @max_guess = 8
    @code_length = 4
    @code_base = 6
    @validate = Regexp.new("[^1-#{@code_base}]")

    @guesser = Player.new("Kihara", @max_guess, @code_length)
    @mastermind = Computer.new("BuddytheRat")

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

    Good luck! [Press Enter to Start]
    """
    gets

    @code = new_code

    game_loop
  end

  def code_invalid?(code)
    @validate.match(code) || code.length != @code_length
  end

  def out_of_guesses?
    @guesser.guess(@max_guess).none? { |g| g == " " }
  end

  def new_code
    puts "(#{@code_length} digits, 1-#{@code_base} only.)"
    code = ask("Mastermind, please enter your code:") { |q| q.echo = false }
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
    code = @code.dup
    hint = guess.each_with_index.map do |num, i|
      if num == code[i]
        code[i] = 0
        num = 2
      elsif  code.any? { |num2| num2 == num }
        code[code.index(num)] = 0
        num = 1
      else
        num = 0
      end
    end
    puts hint.inspect

    guess_data = {
      guess: guess,
      hint: hint.sort
    }
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
    loop do
      system('cls')
      @board.display(@guesser.guesses)
      display_alerts
      break if out_of_guesses?
      guess = new_guess
      guess_data = compare_guess(guess)
      @guesser.add_guess(guess_data)
    end
  end
end

@game = Mastermind.new()