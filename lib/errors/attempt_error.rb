module Codebreaker
  module Errors
    class AttemptError < StandardError
      def initialize
        super(I18n.t(:invalid_attempt))
      end
    end
  end
end
