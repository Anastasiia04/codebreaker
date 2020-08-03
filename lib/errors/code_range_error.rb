module Codebreaker
  module Errors
    class CodeRangeError < StandardError
      def initialize
        super(I18n.t(:code_range))
      end
    end
  end
end
