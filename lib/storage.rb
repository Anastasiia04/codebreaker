require 'fileutils'

module Codebreaker
  module Storage
    FOLDER_NAME = 'db'.freeze
    FILE_NAME = 'statistics.yml'.freeze
    PATH_TO_FILE = File.join(FOLDER_NAME, FILE_NAME)

    def initialize
      Dir.mkdir(PATH_TO_FILE)
    end

    def save_to_file(data)
      File.open(PATH_TO_FILE, 'a') { |file| file.write(data.to_yaml) }
    end

    def file_exist
      File.file?(PATH_TO_FILE)
    end

    def load_from_file
      Psych.load_stream(File.read(PATH_TO_FILE))
    end
  end
end
