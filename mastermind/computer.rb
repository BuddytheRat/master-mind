class Computer < Player
  def initialize(name, max_guess, code_length, code_base)
    super(name, max_guess, code_length)
    @code_length = code_length
    @correct = Array.new(code_length)
    @wrong_pos = Array.new
    @wrong = Array.new
    @code_base = code_base
  end

  def input_code
    @correct.map do |num|
      num = rand.()      
    end
  end

  def input_secret_code
    min_code_str = '1' * @code_length
    min_code = min_code_str.to_i
    max_code_str = @code_base.to_s * @code_length
    max_code = max_code_str.to_i
    rand(min_code..max_code).to_s
  end
end