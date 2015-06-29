class Player
	attr_reader :name, :guesses
  def initialize(name, max_guess, code_length)
    @name = name
    @guess_count = 0
    @guesses = Array.new(max_guess) do 
      {
        guess: Array.new(code_length, " "),
        hint: Array.new(code_length, " ")
      }
    end
  end

  def add_guess(guess_data)
    @guesses[@guess_count] = guess_data
    @guess_count += 1
  end

  def guess(num)
    @guesses[num-1][:guess]
  end

  def hint(num)
    @guesses[num-1][:hint]
  end

  def input_code
    gets.chomp
  end

end