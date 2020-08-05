module Codebreaker
  class Game
    attr_reader :user, :count_minus, :count_plus, :difficulty, :attempts, :hints, :secret_hash

    LENGTH_CODE = 4
    RANGE_SECRET_NUMBER = 6

    def initialize
      @secret_hash = generate_secret
      @number_for_hint = @secret_hash.values.shuffle
    end

    def generate_secret
      Hash[(0...LENGTH_CODE).zip Array.new(LENGTH_CODE) { rand(1...RANGE_SECRET_NUMBER) }]
    end

    def change_secret_hash(hash)
      @secret_hash = hash
    end

    def create_user(name)
      @user = User.new(name)
    end

    def choose_difficulty(difficulty)
      @difficulty = Difficulty.new(difficulty)
      @attempts = @difficulty.attempts
      @hints = @difficulty.hints
    end

    def hint!
      return false if @hints.zero?

      @hints -= 1
      @number_for_hint.pop
    end

    def check_attempt(user_string)
      @user_hash = Hash[(0..LENGTH_CODE).zip user_string.split('').map(&:to_i)]
      @attempts -= 1
      compare_hashes(@secret_hash)
    end

    def compare_hashes(secret_hash)
      @count_plus = 0
      @count_minus = 0
      secret_hash.merge(@user_hash) do |_k, o, n|
        @user_hash.reject! { |_key, val| val == n } && @count_plus += 1 if o == n
      end
      secret_hash.select { |_, value| @user_hash.value? value }.size.times { @count_minus += 1 }
    end

    def to_h
      { name: @user.name, difficult: @difficulty.title,
        total_attempts: @difficulty.attempts, attempts: @difficulty.attempts - @attempts,
        total_hints: @difficulty.hints, hints: @difficulty.hints - @hints }
    end

    def save
      Storage.new.save_to_file(to_h)
    end
  end
end
