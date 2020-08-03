RSpec.describe Codebreaker::Game do
  NAME = { valid_name: 'name', invalid_name: 'na' }.freeze
  DIFFICULTY = { easy: 'easy', hell: 'hell', medium: 'medium', invalid: 'diff' }.freeze
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
      game.choose_difficulty(DIFFICULTY[:easy])
      game.change_secret_hash({ 0 => 6, 1 => 5, 2 => 4, 3 => 3 })
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
      game.choose_difficulty(DIFFICULTY[:easy])
      game.change_secret_hash({ 0 => 1, 1 => 2, 2 => 3, 3 => 4 })
    end

    [['3124', [1, 3]], ['1524', [2, 1]], ['1234', [4, 0]]].each do |guess, result|
      it 'has correct answer also' do
        game.check_attempt(guess)
        expect([game.count_plus, game.count_minus]).to eql(result)
      end
    end
  end

  describe 'hint' do
    subject(:game) { described_class.new }

    it 'show hint' do
      game.choose_difficulty(DIFFICULTY[:hell])
      game.hint!
      expect(game.hints) == 1
    end

    it 'return false if hints end' do
      game.choose_difficulty(DIFFICULTY[:hell])
      game.hint!
      expect(game.hint!).to eq(false)
    end
  end

  describe 'enter easy difficulty' do
    subject(:game) { described_class.new }

    before do
      game.choose_difficulty(DIFFICULTY[:easy])
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
      game.choose_difficulty(DIFFICULTY[:medium])
    end

    it 'shoud have choose right attempts' do
      expect(game.attempts).to eq(10)
    end

    it 'shoud have choose right hints' do
      expect(game.hints).to eq(1)
    end
  end

  describe 'create_user' do
    subject(:game) { described_class.new }

    it 'error if name invalid' do
      error = Codebreaker::Errors::LengthError
      expect { game.create_user(NAME[:invalid_name]) }.to raise_error(error)
    end

    it 'create user if name valid' do
      game.create_user(NAME[:valid_name])
      expect(game.user.name).to eq(NAME[:valid_name])
    end
  end

  describe 'choose_invalid_difficulty' do
    subject(:game) { described_class.new }

    it 'error in difficulty invalid' do
      error = Codebreaker::Errors::IncludeError
      expect { game.choose_difficulty(DIFFICULTY[:invalid]) }.to raise_error(error)
    end

    it 'create difficulty if title valid' do
      game.choose_difficulty(DIFFICULTY[:hell])
      expect(game.difficulty.title).to eq(DIFFICULTY[:hell])
    end
  end
end
