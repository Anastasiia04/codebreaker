module Codebreaker
  module Errors
    class CodeLengthError < StandardError
      def initialize
        super(I18n.t(:code_length))
      end
    end
  end
end
