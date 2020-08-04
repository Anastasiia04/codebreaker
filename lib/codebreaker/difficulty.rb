module Codebreaker
  class Difficulty
    attr_reader :title, :attempts, :hints, :difficulty

    LIST = {
      easy: { attempts: 15, hints: 2, title: 'easy' },
      medium: { attempts: 10, hints: 1, title: 'medium' },
      hell: { attempts: 5, hints: 1, title: 'hell' }
    }.freeze

    def initialize(difficulty)
      Validate.include?(LIST.keys, difficulty.to_sym)
      difficulty = LIST[difficulty.to_sym]
      @attempts = difficulty[:attempts]
      @hints = difficulty[:hints]
      @title = difficulty[:title]
    end
  end
end
