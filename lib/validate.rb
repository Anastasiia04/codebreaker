module Validate
  def validate_name(user_string)
    user_string.size >= 3 && user_string.size <= 20 ? true : false
  end

  def validate_attempt(user_string)
    return false unless user_string.to_i.positive? || user_string.size < @length_code || user_string.size > @length_code

    arr_of_num = user_string.to_i.digits.map { |num| num if (1..@range_sectret_number).to_a.include? num }.compact
    arr_of_num.size >= @length_code ? (return true) : (return false)
  end
end
