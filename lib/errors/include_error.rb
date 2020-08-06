module Codebreaker
  module Errors
    class IncludeError < StandardError
      def initialize
        super(I18n.t(:not_include))
      end
    end
  end
end
