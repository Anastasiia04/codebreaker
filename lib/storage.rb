require 'fileutils'

module Codebreaker
  module Storage
    FOLDER_NAME = 'db'.freeze
    FILE_NAME = 'statistics.yml'.freeze
    PATH_TO_FILE = File.join(FOLDER_NAME, FILE_NAME)

    def create_folder
      Dir.mkdir(FOLDER_NAME) && File.new(PATH_TO_FILE, 'w') until file_exist
    end

    def save_to_file(data)
      create_folder
      File.open(PATH_TO_FILE, 'a') { |file| file.write(data.to_yaml) }
    end

    def file_exist
      File.exist?(PATH_TO_FILE)
    end

    def load_from_file
      create_folder
      Psych.load_stream(File.read(PATH_TO_FILE))
    end
  end
end
