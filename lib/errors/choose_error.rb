module Codebreaker
  module Errors
    class ChooseError < StandardError
      def initialize
        super(puts 'Invalid difficulty.')
      end
    end
  end
end
