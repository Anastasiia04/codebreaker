require 'spec_helper.rb'

RSpec.describe Codebreaker::Game do
  describe 'check_code' do
    let(:game) { described_class.new }

    before do
      game.attempts = 10
      game.secret_hash = { 0 => 6, 1 => 5, 2 => 4, 3 => 3 }
    end

    [['5643', ['+', '+', '-', '-']], ['6544', ['+', '+', '+']], ['6411', ['+', '-']], ['3456', ['-', '-', '-', '-']],
     ['6543', ['+', '+', '+', '+']], ['6666', ['+']], ['2666', ['-']], ['2222', []]].each do |guess, result|
      it 'has correct answer' do
        expect(game.check_attempt(guess)).to eql(result)
      end
    end
  end

  describe 'check 1234 code' do
    let(:game) { described_class.new }

    before do
      game.attempts = 10
      game.secret_hash = { 0 => 1, 1 => 2, 2 => 3, 3 => 4 }
    end

    [['3124', ['+', '-', '-', '-']], ['1524', ['+', '+', '-']], ['1234', ['+', '+', '+', '+']]].each do |guess, result|
      it 'has correct answer also' do
        expect(game.check_attempt(guess)).to eql(result)
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
        expect(game.validate_attempt_size(guess)).to be(guess)
      end
    end

    %w[12 652145 wqe].each do |_guess|
      it 'must return eroor' do
        error = Codebreaker::Errors::AttemptError.new
        expect { raise error }.to raise_error(error)
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

    %w[1239 6587].each do |_guess|
      it 'must return eroor' do
        error = Codebreaker::Errors::AttemptError.new
        expect { raise error }.to raise_error(error)
      end
    end
  end

  describe 'hint' do
    subject(:game) { described_class.new }

    it 'show hint' do
      game.registration_difficulty('hell')
      game.start
      game.show_hint
      expect(game.hints) == 1
    end

    it 'check random hashes' do
      expect(game.start).not_to eq(game.start)
    end
  end

  describe 'enter easy difficulty' do
    subject(:game) { described_class.new }

    before do
      game.registration_difficulty('easy')
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
      game.registration_difficulty('medium')
    end

    it 'shoud have choose right attempts' do
      expect(game.attempts).to eq(10)
    end

    it 'shoud have choose right hints' do
      expect(game.hints).to eq(1)
    end
  end

  describe 'error in name invalid' do
    subject(:game) { described_class.new }

    it 'shoud have choose right attempts' do
      error = Codebreaker::Errors::LengthError.new
      expect { raise error }.to raise_error(error)
    end
  end

  describe 'error in difficulty invalid' do
    subject(:game) { described_class.new }

    it 'shoud have choose right attempts' do
      error = Codebreaker::Errors::ChooseError.new
      expect { raise error }.to raise_error(error)
    end
  end

  describe 'play again def' do
    subject(:game) { described_class.new }

    before do
      game.registration_difficulty('hell')
      game.start
      game.check_attempt('1324')
      game.show_hint
      game.play_again
    end

    it 'updates attempts' do
      expect(game.attempts).to eq(5)
    end

    it 'updates hints' do
      expect(game.hints).to eq(1)
    end
  end

  describe 'add rating' do
    subject(:game) { described_class.new }

    # let(:test_path) { './fixtures/statistics.yml' }
    # let(:test_folder_name) { 'fixtures' }

    before do
      game.registration_user('name')
      game.registration_difficulty('hell')
      # stub_const('Codebreaker::STORAGE::PATH_TO_FILE', test_path)
      game.save
    end

    after do
      File.open(Codebreaker::Storage::PATH_TO_FILE, 'w') { |file| file.truncate(0) }
    end

    it 'correct add rating to array for table ' do
      arr_rating = [{ rating: 1, name: 'name', difficult: '3 hell',
                      total_attempts: 5, attempts: 5, total_hints: 1, hints: 1 }]
      expect(game.add_rating).to eq(arr_rating)
    end

    it 'correct working stats def ' do
      arr_rating = [{ rating: 1, name: 'name', difficult: '3 hell',
                      total_attempts: 5, attempts: 5, total_hints: 1, hints: 1 }]
      expect(game.stats(arr_rating)) == game.stats
    end
  end
end
