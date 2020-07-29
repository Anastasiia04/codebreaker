require 'errors/attempt_error.rb'

module Validate
  def size_between?(verifiable_value, minimum, maximum)
    verifiable_value.size.between?(minimum, maximum)
  end

  def validate_attempt_size(user_string)
    length_code = Codebreaker::Game::LENGTH_CODE
    if user_string.size > length_code || user_string.size < length_code || user_string.to_i.negative?
      raise Codebreaker::Errors::AttemptError
    end

    user_string
  end

  def validate_attempt_range(user_string)
    arr_of_num = user_string.to_i.digits.map do |num|
      num if (1..Codebreaker::Game::RANGE_SECRET_NUMBER).to_a.include? num
    end .compact
    raise Codebreaker::Errors::AttemptError unless arr_of_num.size >= Codebreaker::Game::LENGTH_CODE

    user_string
  end
end
