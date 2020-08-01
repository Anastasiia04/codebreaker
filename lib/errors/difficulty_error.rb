module Codebreaker
  module Errors
    class DifficultyError < StandardError
      def initialize
        super(I18n.t(:invalid_difficulty))
      end
    end
  end
end
