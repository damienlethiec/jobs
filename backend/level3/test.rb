require_relative 'main.rb'

def run
  Runner.new.run
  puts real_output == expected_output ? "Success" : "Failure"
end

def real_output
  File.read(File.join(__dir__, "data/real_output.json")).chomp
end

def expected_output
  File.read(File.join(__dir__, "data/expected_output.json")).chomp
end

run
