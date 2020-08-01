module Codebreaker
  module Errors
    class NameError < StandardError
      def initialize
        super(I18n.t(:invalid_name))
      end
    end
  end
end
