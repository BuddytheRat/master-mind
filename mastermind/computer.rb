class Computer < Player
  def initialize(name, max_guess, code_length, code_base)
    super(name, max_guess, code_length)

    @code_length = code_length
    @code_base = code_base

    @correct = Array.new(code_length)
    @wrong_pos = Array.new
    @wrong = Array.new

    min_code_str = '1' * @code_length
    max_code_str = @code_base.to_s * @code_length
    @min_code = min_code_str.to_i
    @max_code = max_code_str.to_i
  end

  def input_code
    rand(@min_code..@max_code).to_s
  end

  def input_secret_code
    rand(@min_code..@max_code).to_s
  end
end