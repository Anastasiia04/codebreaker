require 'terminal-table'
require_relative 'validate.rb'
require 'codebreaker/version'

module Codebreaker
  class Error < StandardError; end

  class Game
    PATH = 'statistics.yml'.freeze
    include Validate
    attr_accessor :user_name, :difficulty, :attempts, :hints, :total_attempts, :total_hints, :win,
                  :secret_hash, :symbol_guess_position, :symbol_guess_number, :count_minus, :count_plus,
                  :length_code, :range_sectret_number

    def initialize
      @attempts = 0
      @hints = 0
      @difficulty = ''
      @count_minus = 0
      @count_plus = 0
      @symbol_guess_position = '+'
      @symbol_guess_number = '-'
      @length_code = 4
      @range_sectret_number = 6
    end

    def enter_user_name(string)
      @user_name = string
    end

    DIFFICULTY = {
      "easy": [15, 2, '1 easy'],
      "medium": [10, 1, '2 medium'],
      "hell": [5, 1, '3 hell']
    }.freeze

    def choose_difficulty(choose_difficult_string)
      @difficulty = DIFFICULTY[choose_difficult_string.to_sym]
      @attempts = @difficulty[0]
      @hints = @difficulty[1]
      @difficulty = @difficulty[2]
      @total_attempts = @attempts
      @total_hints = @hint
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

    def stats
      rows = []
      add_rating.each { |d| rows << d.map { |_k, v| v } }
      to_table(rows)
    end

    def sort_data
      data = Psych.load_stream(File.read(PATH))
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
      compare_hashes
      @count_plus.times { array_of_guess_position << @symbol_guess_position }
      @count_minus.times { array_of_guess_position << @symbol_guess_number }
      array_of_guess_position
    end

    def compare_hashes
      secret_hash = 0
      secret_hash = @secret_hash
      secret_hash.merge(@user_hash) { |k, o, n| secret_hash.reject! { |key| key == k } && @count_plus += 1 if o == n }
      secret_hash.select { |_, value| @user_hash.value? value }.size.times { @count_minus += 1 }
    end

    def save
      hash = {  name: @user_name, difficult: @difficulty,
                total_attempts: @total_attempts, attempts: @attempts,
                total_hints: @total_hints, hints: @hints }
      File.open(PATH, 'a') { |file| file.write(hash.to_yaml) }
    end

    def play_again
      @attempts = @total_attempts
      @hints = @total_hints
      @count_minus = 0
      @count_plus = 0
    end
  end
end
