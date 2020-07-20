module Codebreaker
  module Errors
    class AttemptError < StandardError
      def initialize
        super(puts 'You enter invalid attempt.')
      end
    end
  end
end
