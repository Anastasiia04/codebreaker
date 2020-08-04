require 'spec_helper.rb'

RSpec.describe Codebreaker::Validate do
  describe 'validate attempt size' do
    let(:game) { Codebreaker::Game.new }

    before do
      game.change_secret_hash({ 0 => 1, 1 => 2, 2 => 3, 3 => 4 })
    end

    %w[1234 6521 3265].each do |guess|
      it 'must return string' do
        expect(described_class.code_length?(guess)).to be(nil)
      end
    end

    %w[12 652145 123].each do |guess|
      it 'must return error' do
        expect { described_class.code_length?(guess) }.to raise_error(Codebreaker::Errors::CodeLengthError)
      end
    end
  end

  describe 'validate attempt range' do
    let(:validate) { described_class.new }
    let(:game) { Codebreaker::Game.new }

    before do
      game.change_secret_hash({ 0 => 1, 1 => 2, 2 => 3, 3 => 4 })
    end

    %w[1234 6521 3265].each do |guess|
      it 'must return string' do
        expect(described_class.code_range?(guess)).to eq(nil)
      end
    end

    %w[1239 6587].each do |guess|
      it 'must return eroor' do
        expect { described_class.code_range?(guess) }.to raise_error(Codebreaker::Errors::CodeRangeError)
      end
    end
  end
end
