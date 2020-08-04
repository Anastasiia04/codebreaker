module Codebreaker
  class User
    attr_reader :name

    NAME_SIZE = { minimum: 3, maximum: 20 }.freeze

    def initialize(name)
      @name = name
      Validate.length?(@name, NAME_SIZE[:minimum], NAME_SIZE[:maximum])
    end
  end
end
