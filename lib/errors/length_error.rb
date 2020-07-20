module Codebreaker
  module Errors
    class LengthError < StandardError
      def initialize
        super(puts 'Invalid name.')
      end
    end
  end
end
