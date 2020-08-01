module Validate
  def size_between?(verifiable_value, minimum, maximum)
    verifiable_value.size.between?(minimum, maximum)
  end

  def valid_include?(check_array, verifiable_value)
    check_array.include?(verifiable_value)
  end

  def check_attempts_existing(user_string)
    length_code = Codebreaker::Game::LENGTH_CODE
    until size_between?(user_string, length_code, length_code) || user_string.to_i.negative?
      raise Codebreaker::Errors::AttemptError
    end

    user_string
  end

  def validate_attempt_range(user_string)
    user_string.to_i.digits.each do |number|
      raise Codebreaker::Errors::AttemptError unless (1..Codebreaker::Game::RANGE_SECRET_NUMBER).cover?(number)
    end

    user_string
  end
end
