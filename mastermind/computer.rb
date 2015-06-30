class Computer < Player
  require 'set'
  
  def initialize(name, max_guess, code_length, code_base)
    super(name, max_guess, code_length)

    @code_length = code_length
    @code_base = code_base

    @possible = (1..@code_base).to_a * 500
    @not_possible = Set.new
    @past_guesses = Array.new
    @digits_known = false

    min_code_str = '1' * @code_length
    max_code_str = @code_base.to_s * @code_length
    @min_code = min_code_str.to_i
    @max_code = max_code_str.to_i
  end

  def think(guess_data)
    hint_int = guess_data[:hint].join('').to_i

    #waste time
    sleep(1.0/10.0)

    # If hint is all zeroes, no longer use guessed digits.
    if hint_int == 0
      @not_possible += guess_data[:guess]
    end

    # If none of hint are zeroes, use only last guessed digits.
    if hint_int > 1000
      @digits_known = guess_data[:guess]
    end

    # Build probability matrix.
    if hint_int >= 100 && !@digits_known
      @possible += guess_data[:guess] * (hint_int * 10)
    end
    @possible -= @not_possible.to_a
  end

  def display_brain
    possibility_matrix.inspect + "\n" + @not_possible.inspect
  end

  def possibility_matrix
    matrix = Hash.new(0)
    @possible.each do |num|
      matrix[num] += 1
    end
    matrix
  end

  def input_code
    guess = Array.new
    if @digits_known
      guess = @digits_known.shuffle
    else
      @code_length.times do
        guess << @possible.sample
      end
    end
    return input_code if @past_guesses.include? (guess)
    @past_guesses << guess
    guess.join('').to_s
  end

  def input_secret_code
    rand(@min_code..@max_code).to_s
  end
end