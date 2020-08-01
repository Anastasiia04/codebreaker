require 'spec_helper.rb'

RSpec.describe Codebreaker::Game do
  describe 'create games' do
    let(:game1) { described_class.new }
    let(:game2) { described_class.new }

    it 'have different secret_hash' do
      expect(game1.secret_hash).not_to eq(game2.secret_hash)
    end
  end

  describe 'check_code' do
    let(:game) { described_class.new }

    before do
      game.attempts = 10
      game.secret_hash = { 0 => 6, 1 => 5, 2 => 4, 3 => 3 }
    end

    [['5643', [2, 2]], ['6544', [3, 0]], ['6411', [1, 1]], ['3456', [0, 4]],
     ['6543', [4, 0]], ['6666', [1, 0]], ['2666', [0, 1]], ['2222', [0, 0]]].each do |guess, result|
      it 'has correct answer' do
        game.check_attempt(guess)
        expect([game.count_plus, game.count_minus]).to eql(result)
      end
    end
  end

  describe 'check 1234 code' do
    let(:game) { described_class.new }

    before do
      game.attempts = 10
      game.secret_hash = { 0 => 1, 1 => 2, 2 => 3, 3 => 4 }
    end

    [['3124', [1, 3]], ['1524', [2, 1]], ['1234', [4, 0]]].each do |guess, result|
      it 'has correct answer also' do
        game.check_attempt(guess)
        expect([game.count_plus, game.count_minus]).to eql(result)
      end
    end
  end

  describe 'validate attempt size' do
    let(:game) { described_class.new }

    before do
      game.secret_hash = { 0 => 1, 1 => 2, 2 => 3, 3 => 4 }
    end

    %w[1234 6521 3265].each do |guess|
      it 'must return string' do
        expect(game.check_attempts_existing(guess)).to be(guess)
      end
    end

    %w[12 652145 wqe].each do |guess|
      it 'must return error' do
        expect { game.check_attempts_existing(guess) }.to raise_error(Codebreaker::Errors::AttemptError)
      end
    end
  end

  describe 'validate attempt range' do
    let(:game) { described_class.new }

    before do
      game.secret_hash = { 0 => 1, 1 => 2, 2 => 3, 3 => 4 }
    end

    %w[1234 6521 3265].each do |guess|
      it 'must return string' do
        expect(game.validate_attempt_range(guess)).to be(guess)
      end
    end

    %w[1239 6587].each do |guess|
      it 'must return eroor' do
        error = Codebreaker::Errors::AttemptError
        expect { game.validate_attempt_range(guess) }.to raise_error(error)
      end
    end
  end

  describe 'hint' do
    subject(:game) { described_class.new }

    it 'show hint' do
      game.choose_difficulty('hell')
      game.hint!
      expect(game.hints) == 1
    end

    it 'return false if hints end' do
      game.choose_difficulty('hell')
      game.hint!
      expect(game.hint!).to eq(false)
    end
  end

  describe 'enter easy difficulty' do
    subject(:game) { described_class.new }

    before do
      game.choose_difficulty('easy')
    end

    it 'shoud have choose right attempts' do
      expect(game.attempts).to eq(15)
    end

    it 'shoud have choose right hints' do
      expect(game.hints).to eq(2)
    end
  end

  describe 'enter medium difficulty' do
    subject(:game) { described_class.new }

    before do
      game.choose_difficulty('medium')
    end

    it 'shoud have choose right attempts' do
      expect(game.attempts).to eq(10)
    end

    it 'shoud have choose right hints' do
      expect(game.hints).to eq(1)
    end
  end

  describe 'create_user#1' do
    subject(:game) { described_class.new }

    it 'error if name invalid' do
      error = Codebreaker::Errors::NameError
      expect { game.create_user('nm') }.to raise_error(error)
    end
  end

  describe 'create_user#2' do
    subject(:game) { described_class.new }

    it 'create user if name valid' do
      game.create_user('name')
      expect(game.user.name).to eq('name')
    end
  end

  describe 'choose_difficulty#1' do
    subject(:game) { described_class.new }

    it 'error in difficulty invalid' do
      error = Codebreaker::Errors::DifficultyError
      expect { game.choose_difficulty('nm') }.to raise_error(error)
    end
  end

  describe 'choose_difficulty#2' do
    subject(:game) { described_class.new }

    it 'create difficulty if title valid' do
      game.choose_difficulty('hell')
      expect(game.difficulty.title).to eq('hell')
    end
  end

  describe 'sort data' do
    subject(:game) { described_class.new }

    let(:test_folder_name) { './spec/fixtures/statistics.yml' }

    before do
      game.create_user('name')
      game.choose_difficulty('easy')
      stub_const('Codebreaker::Storage::PATH_TO_FILE', test_folder_name)
      game.save
      game.create_user('name1')
      game.choose_difficulty('hell')
      game.save
      game.create_user('name2')
      game.choose_difficulty('medium')
      game.save
    end

    after do
      File.open(test_folder_name, 'w') { |file| file.truncate(0) }
    end

    it 'correct add rating to array for table ' do
      arr_rating = [{ name: 'name1', difficult: 'hell', total_attempts: 5, attempts: 5, total_hints: 1, hints: 1 },
                    { name: 'name2', difficult: 'medium', total_attempts: 10, attempts: 10, total_hints: 1, hints: 1 },
                    { name: 'name', difficult: 'easy', total_attempts: 15, attempts: 15, total_hints: 2, hints: 2 }]
      expect(game.stats).to eq(arr_rating)
    end
  end
end
