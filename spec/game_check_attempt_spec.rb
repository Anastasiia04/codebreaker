require 'rspec'
require_relative '../lib/codebreaker.rb'

RSpec.describe Codebreaker::Game do
  let(:game) { Codebreaker::Game.new }
  before(:each) do
    game.secret_hash = { 0 => 6, 1 => 5, 2 => 4, 3 => 3 }
  end

  it 'should have correct answer' do
    expect(game.check_attempt('5643')).to eq(['+', '+', '-', '-'])
  end

  it 'should have correct answer' do
    expect(game.check_attempt('6544')).to eq(['+', '+', '+'])
  end

  it 'should have correct answer' do
    expect(game.check_attempt('6411')).to eq(['+', '-'])
  end

  it 'should have correct answer' do
    expect(game.check_attempt('3456')).to eq(['-', '-', '-', '-'])
  end

  it 'should have correct answer' do
    expect(game.check_attempt('6666')).to eql(['+'])
  end

  it 'should have correct answer' do
    expect(game.check_attempt('2666')).to eq(['-'])
  end

  it 'should have correct answer' do
    expect(game.check_attempt('2222')).to eq([])
  end
end
