require 'rspec'

RSpec.describe Codebreaker::Game do
  let(:game) { Codebreaker::Game.new }
  before(:each) do
    game.secret_hash = { 0 => 6, 1 => 5, 2 => 4, 3 => 3 }
  end

  it 'shoud have choose right difficulty' do
    game.choose_difficulty('easy')
    expect(game.attempts).to eq(15)
    expect(game.hints).to eq(2)
    expect(game.difficulty).to eq('1 easy')
    game.choose_difficulty('medium')
    expect(game.attempts).to eq(10)
    expect(game.hints).to eq(1)
    expect(game.difficulty).to eq('2 medium')
    game.choose_difficulty('hell')
    expect(game.attempts).to eq(5)
    expect(game.hints).to eq(1)
    expect(game.difficulty).to eq('3 hell')
  end
end
