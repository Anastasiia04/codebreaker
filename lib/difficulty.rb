module Codebreaker
  class Difficulty
    include Errors
    include Validate

    attr_reader :title, :attempts, :hints, :difficulty

    DIFFICULTY = {
      easy: { attempts: 15, hints: 2, title: 'easy' },
      medium: { attempts: 10, hints: 1, title: 'medium' },
      hell: { attempts: 5, hints: 1, title: 'hell' }
    }.freeze

    def initialize(difficulty)
      validate_difficulty(difficulty)
      difficulty = DIFFICULTY[difficulty.to_sym]
      @attempts = difficulty[:attempts]
      @hints = difficulty[:hints]
      @title = difficulty[:title]
    end

    def validate_difficulty(difficulty)
      valid_difficulty_title = DIFFICULTY.values.map { |value| value[:title] }
      raise DifficultyError until valid_difficulty_title.include?(difficulty)

      difficulty
    end
  end
end
