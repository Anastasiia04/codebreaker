require 'rspec'
require 'psych'
require 'yaml'

RSpec.describe Codebreaker::Game do
  let(:game) { Codebreaker::Game.new }

  it 'show hint' do
    game.choose_difficulty('easy')
    game.start
    game.show_hint
    expect(game.hints) == 1
  end

  it 'check random hashes' do
    expect(game.start).not_to eq(game.start)
  end
end
