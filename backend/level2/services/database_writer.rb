require 'json'

class DatabaseWriter
  attr_reader :output, :file_path

  def initialize(data, file_name)
    @output = JSON.pretty_generate(data)
    @file_path = File.join(__dir__, "../data/#{file_name}")
  end

  def write
    File.open(file_path, "w") do |file|
      file.write(output)
    end
  end
end
