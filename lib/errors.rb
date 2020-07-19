module Codebreaker
  module Errors
    class LengthError < StandardError
      def initialize
        super(puts 'Invalid name.')
      end
    end

    class ChooseError < StandardError
      def initialize
        super(puts 'Invalid difficulty.')
      end
    end
  end
end
