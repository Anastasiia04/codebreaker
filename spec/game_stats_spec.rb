require 'rspec'
require 'psych'
require 'terminal-table'

RSpec.describe Codebreaker::Game do
  PATH = 'statistics.yml'.freeze
  let(:game) { Codebreaker::Game.new }

  before(:each) do
    string = 'nnbb'
    game.enter_user_name(string)
    game.choose_difficulty('easy')
    game.save
    game.enter_user_name(string)
    game.choose_difficulty('hell')
    game.save
  end

  it 'should correct sort data' do
    @stats_arr = [{ name: 'nnbb,', difficult: '3 hell', total_attempts: 5, attempts: 5, total_hints: 1, hints: 1 },
                  { name: 'nnbb,', difficult: '1 easy', total_attempts: 15, attempts: 15, total_hints: 2, hints: 2 }]
    expect(game.sort_data) == @stats_arr
  end
  it 'should correctly display the table ' do
    rows = game.add_rating
    table = Terminal::Table.new headings:
          ['Rating', 'Name', 'Difficulty', 'Attempts Total', 'Attempts Used', 'Hints Total', 'Hints Used'], rows: rows
    expect(game.stats) == table
  end
end
