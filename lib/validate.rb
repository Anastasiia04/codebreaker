require 'errors/attempt_error.rb'

module Validate
  def size_between?(verifiable_value, minimum, maximum)
    verifiable_value.size.between?(minimum, maximum)
  end

  def validate_attempt_size(user_string)
    if user_string.size > @length_code || user_string.size < @length_code || user_string.to_i.negative?
      raise Codebreaker::Errors::AttemptError
    end

    user_string
  end

  def validate_attempt_range(user_string)
    arr_of_num = user_string.to_i.digits.map { |num| num if (1..@range_sectret_number).to_a.include? num }.compact
    raise Codebreaker::Errors::AttemptError unless arr_of_num.size >= @length_code

    user_string
  end
end
