module Codebreaker
  class Validate
    def self.length?(verifiable_value, minimum, maximum)
      raise Codebreaker::Errors::LengthError unless verifiable_value.size.between?(minimum, maximum)
    end

    def self.include?(check_values, verifiable_value)
      error = Codebreaker::Errors::IncludeError.new(check_values, verifiable_value)
      raise error unless check_values.include?(verifiable_value)
    end

    def self.code_length?(user_string)
      length_code = Codebreaker::Game::LENGTH_CODE
      raise Codebreaker::Errors::CodeLengthError unless user_string.size.between?(length_code, length_code)
    end

    def self.code_range?(user_string)
      range = (1..Codebreaker::Game::RANGE_SECRET_NUMBER)
      raise Codebreaker::Errors::CodeRangeError unless user_string.chars.all? { |number| range.include?(number.to_i) }
    end
  end
end
