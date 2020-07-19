module Validate
  def size_between?(verifiable_value, minimum, maximum)
    verifiable_value.size.between?(minimum, maximum)
  end

  def validate_attempt(user_string)
    return false unless user_string.to_i.positive?
    return false if user_string.size < @length_code
    return false if user_string.size > @length_code

    arr_of_num = user_string.to_i.digits.map { |num| num if (1..@range_sectret_number).to_a.include? num }.compact
    arr_of_num.size >= @length_code ? (return true) : (return false)
  end
end
