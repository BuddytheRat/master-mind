class Board
	def initialize(code_length, max_guess)
		@border = {
			top: '-',
			side: '|',
			corner: 'o'
		}
    @code_length = code_length
    @max_guess = max_guess
	end

	def display(guesses)
    row_top = @border[:corner] + (@border[:top] * ((@code_length * 4) + 3)) + @border[:corner] + "\n"
    guesses.reverse.each do |guess_data|
      print row_top
      print @border[:side]
      guess_data[:guess].each { |num| print num.to_s.center(3, " ") }
      print @border[:side] + " "
      guess_data[:hint].each { |num| print num }
      print " " + @border[:side] + "\n"
    end
    print row_top
	end
end