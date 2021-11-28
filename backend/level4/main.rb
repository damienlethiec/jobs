require_relative 'models/rental.rb'
require_relative 'services/database_writer.rb'

class Runner
  def run
    output_hash = Rental.to_money_movements_hash
    DatabaseWriter.new(output_hash, 'real_output.json').write
  end
end

Runner.new.run
