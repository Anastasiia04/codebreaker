require 'terminal-table'
require 'psych'
require 'validate.rb'
require 'errors.rb'
require 'user.rb'
require 'difficulty.rb'
require 'codebreaker/version'

module Codebreaker
  class Error < StandardError; end
  include Errors
  include Validate
  class Game
    PATH = 'statistics.yml'.freeze
    include Validate
    attr_accessor :user, :attempts, :hints, :win,
                  :secret_hash, :symbol_guess_position, :symbol_guess_number, :count_minus, :count_plus,
                  :length_code, :range_sectret_number

    def initialize(name, difficulty)
      @count_minus = 0
      @count_plus = 0
      @symbol_guess_position = '+'
      @symbol_guess_number = '-'
      @length_code = 4
      @range_sectret_number = 6
      @difficulty = Difficulty.new(difficulty)
      @user = User.new(name)
      @attempts = @difficulty.attempts
      @hints = @difficulty.hints
    end

    def add_rating
      rating = 1
      new_sort_arr = []
      sort_data.each do |data|
        new_sort_arr << { rating: rating }.merge!(data)
        rating += 1
      end
      new_sort_arr
    end

    def stats(data_whith_rating = add_rating)
      rows = []
      data_whith_rating.each { |d| rows << d.map { |_k, v| v } }
      to_table(rows)
    end

    def sort_data(file_name = PATH)
      data = Psych.load_stream(File.read(file_name))
      data.sort_by { |h| [h[:difficult], h[:attempts], h[:hints]] }.reverse
    end

    def to_table(rows)
      Terminal::Table.new headings:
          ['Rating', 'Name', 'Difficulty', 'Attempts Total', 'Attempts Used', 'Hints Total', 'Hints Used'], rows: rows
    end

    def start
      @secret_hash = Hash[(0...@length_code).zip Array.new(@length_code) { rand(1...@range_sectret_number) }]
    end

    def show_hint
      return false if @hints.zero?

      @hints -= 1
      secret_arr_value = @secret_hash.values
      secret_arr_value.delete_at(rand(secret_arr_value.length))
    end

    def check_attempt(user_string)
      @user_hash = Hash[(0...@length_code).zip user_string.split('').map(&:to_i)]
      array_of_guess_position = []
      @attempts -= 1
      secret_hash = @secret_hash
      compare_hashes(secret_hash)
      @count_plus.times { array_of_guess_position << @symbol_guess_position }
      @count_minus.times { array_of_guess_position << @symbol_guess_number }
      array_of_guess_position
    end

    def compare_hashes(secret_hash)
      @count_plus = 0
      @count_minus = 0
      secret_hash.merge(@user_hash) do |_k, o, n|
        @user_hash.reject! { |_key, val| val == n } && @count_plus += 1 if o == n
      end
      secret_hash.select { |_, value| @user_hash.value? value }.size.times { @count_minus += 1 }
    end

    def save(file_name = PATH)
      hash = {  name: @user.name, difficult: @difficulty.title,
                total_attempts: @difficulty.attempts, attempts: @attempts,
                total_hints: @difficulty.hints, hints: @hints }
      File.open(file_name, 'a') { |file| file.write(hash.to_yaml) }
    end

    def play_again
      @attempts = @difficulty.attempts
      @hints = @difficulty.hints
      @count_minus = 0
      @count_plus = 0
    end
  end
end
