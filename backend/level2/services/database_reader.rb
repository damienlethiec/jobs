require 'json'

class DatabaseReader
  attr_reader :file_path

  def initialize(file_name)
    @file_path = File.join(__dir__, "../data/#{file_name}")
  end

  def read
    JSON.parse(File.read(file_path), object_class: OpenStruct)
  end
end
