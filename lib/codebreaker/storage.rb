module Codebreaker
  class Storage
    PATH_TO_FILE = 'db/statistics.yml'.freeze

    def initialize
      Dir.mkdir(File.dirname(PATH_TO_FILE)) && File.new(PATH_TO_FILE, 'w') unless file_exist?
    end

    def save_to_file(data)
      File.open(PATH_TO_FILE, 'a') { |file| file.write(data.to_yaml) }
    end

    def file_exist?
      File.exist?(PATH_TO_FILE)
    end

    def load_from_file
      Psych.load_stream(File.read(PATH_TO_FILE))
    end
  end
end
