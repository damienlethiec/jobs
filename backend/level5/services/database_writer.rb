require 'json'

class DatabaseWriter
  attr_reader :output, :file_path

  def initialize(data, file_name)
    # know issue: extra line for empty array in JSON pretty generate
    # https://stackoverflow.com/questions/58361230/avoiding-extra-lines-in-ruby-json-pretty-generate
    @output = JSON.pretty_generate(data)
                 .gsub(/(?<content>"+")|(?<open>\[)\s+(?<close>\])/m,
                       '\k<open>\k<content>\k<close>')
    @file_path = File.join(__dir__, "../data/#{file_name}")
  end

  def write
    File.open(file_path, "w") do |file|
      file.write(output)
    end
  end
end
