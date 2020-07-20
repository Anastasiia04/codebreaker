require 'validate.rb'
require 'errors/length_error.rb'

module Codebreaker
  class User
    include Errors
    include Validate

    attr_reader :name

    NAME_SIZE = { minimum: 3, maximum: 20 }.freeze

    def initialize(name)
      @name = name
      validate
    end

    private

    def validate
      raise LengthError unless size_between?(@name, NAME_SIZE[:minimum], NAME_SIZE[:maximum])
    end
  end
end
