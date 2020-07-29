require 'fileutils'

module Codebreaker
  module Storage
    FOLDER_NAME = 'db'.freeze
    FILE_NAME = 'statistics.yml'.freeze
    PATH_TO_FILE = File.join(FOLDER_NAME, FILE_NAME)

    def create_folder
      dirname = File.dirname(PATH_TO_FILE)
      FileUtils.mkdir_p(dirname) && File.new(FILE_NAME, 'w') unless File.directory?(dirname)
    end

    def save_to_file(data)
      create_folder
      File.open(PATH_TO_FILE, 'a') { |file| file.write(data.to_yaml) }
    end

    def load_from_file
      create_folder
      Psych.load_stream(File.read(PATH_TO_FILE))
    end
  end
end
