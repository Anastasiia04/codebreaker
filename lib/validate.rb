module Codebreaker
  class Validate
    def length?(verifiable_value, minimum, maximum)
      raise Codebreaker::Errors::LengthError unless verifiable_value.size.between?(minimum, maximum)
    end

    def include?(check_values, verifiable_value)
      error = Codebreaker::Errors::IncludeError.new(check_values, verifiable_value)
      raise error unless check_values.include?(verifiable_value)
    end

    def code_length?(user_string)
      length_code = Codebreaker::Game::LENGTH_CODE
      raise Codebreaker::Errors::CodeLengthError unless user_string.size.between?(length_code, length_code)

      user_string
    end

    def code_range?(user_string)
      user_string.to_i.digits.each do |number|
        raise Codebreaker::Errors::CodeRangeError unless (1..Codebreaker::Game::RANGE_SECRET_NUMBER).cover?(number)
      end

      user_string
    end
  end
end
