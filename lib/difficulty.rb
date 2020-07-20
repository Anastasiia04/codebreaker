require 'validate.rb'
require 'errors/choose_error.rb'

module Codebreaker
  class Difficulty
    include Errors
    include Validate

    attr_accessor :title, :attempts, :hints

    def initialize(difficulty)
      validate_difficulty(difficulty)
      choose_difficulty(difficulty)
    end

    DIFFICULTY = {
      "easy": [15, 2, '1 easy'],
      "medium": [10, 1, '2 medium'],
      "hell": [5, 1, '3 hell']
    }.freeze

    def choose_difficulty(choose_difficult_string)
      @difficulty = DIFFICULTY[choose_difficult_string.to_sym]
      @attempts = @difficulty[0]
      @hints = @difficulty[1]
      @title = @difficulty[2]
    end

    def validate_difficulty(difficulty)
      valid_difficulty_commands = DIFFICULTY.values.map { |key, _v| key }
      raise ChooseError if valid_difficulty_commands.include?(difficulty)

      difficulty
    end
  end
end
