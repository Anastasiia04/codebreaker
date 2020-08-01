require 'terminal-table'
require 'psych'
require 'i18n'
require 'fileutils'
require 'validate.rb'
require 'locale_config.rb'
require 'errors/attempt_error.rb'
require 'errors/difficulty_error.rb'
require 'errors/length_error.rb'
require 'storage.rb'
require 'user.rb'
require 'difficulty.rb'
require 'codebreaker/version'

module Codebreaker
  class Error < StandardError; end

  class Game
    include Validate
    include Errors
    attr_reader :user, :count_minus, :count_plus, :difficulty
    attr_accessor :attempts, :hints, :secret_hash
    LENGTH_CODE = 4
    RANGE_SECRET_NUMBER = 6

    def initialize
      @count_minus = 0
      @count_plus = 0
      @secret_hash = Hash[(0...LENGTH_CODE).zip Array.new(LENGTH_CODE) { rand(1...RANGE_SECRET_NUMBER) }]
      @number_for_hint = @secret_hash.values.shuffle
    end

    def create_user(name)
      @user = User.new(name)
    end

    def choose_difficulty(difficulty)
      @difficulty = Difficulty.new(difficulty)
      @attempts = @difficulty.attempts
      @hints = @difficulty.hints
    end

    def stats
      sort_data
    end

    def sort_data
      difficulty_order = Difficulty::DIFFICULTY.keys
      Storage.new.load_from_file.sort_by { |h| [difficulty_order.index(h[:difficulty]), h[:attempts], h[:hints]] }
    end

    def hint!
      return false if @hints.zero?

      @hints -= 1
      @number_for_hint.pop
    end

    def check_attempt(user_string)
      @user_hash = Hash[(0..LENGTH_CODE).zip user_string.split('').map(&:to_i)]
      @attempts -= 1
      secret_hash = @secret_hash
      compare_hashes(secret_hash)
    end

    def compare_hashes(secret_hash)
      @count_plus = 0
      @count_minus = 0
      secret_hash.merge(@user_hash) do |_k, o, n|
        @user_hash.reject! { |_key, val| val == n } && @count_plus += 1 if o == n
      end
      secret_hash.select { |_, value| @user_hash.value? value }.size.times { @count_minus += 1 }
    end

    def save
      hash = {  name: @user.name, difficult: @difficulty.title,
                total_attempts: @difficulty.attempts, attempts: @attempts,
                total_hints: @difficulty.hints, hints: @hints }
      Storage.new.save_to_file(hash)
    end
  end
end
