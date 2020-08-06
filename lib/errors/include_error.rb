module Codebreaker
  module Errors
    class IncludeError < StandardError
      def initialize(check_values, verifiable_value)
        super(I18n.t(:not_include, values: check_values, value: verifiable_value))
      end
    end
  end
end
