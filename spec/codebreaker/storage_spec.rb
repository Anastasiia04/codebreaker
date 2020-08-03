RSpec.describe Codebreaker::Storage do
  describe 'create storage' do
    let(:storage) { described_class.new }
    let(:test_folder_name) { './spec/fixtures/statistics.yml' }

    before do
      stub_const('Codebreaker::Storage::PATH_TO_FILE', test_folder_name)
    end

    after do
      File.open(test_folder_name, 'w') { |file| file.truncate(0) }
    end

    it 'create statistics.yml file' do
      expect(storage.file_exist?).to eq(true)
    end

    it 'must load empty array' do
      expect(storage.load_from_file).to eq([])
    end

    it 'must load saved data' do
      data = { name: 'name', age: 'age' }
      storage.save_to_file(data)
      expect(storage.load_from_file).to eq([data])
    end
  end
end
