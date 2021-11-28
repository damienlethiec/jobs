require_relative '../services/database_reader.rb'

class Option
  attr_reader :id, :rental, :type, :price_per_day, :beneficiary

  TYPE = [
    { name: "gps", price: 500, beneficiary: "owner" },
    { name: "baby_seat", price: 200, beneficiary: "owner" },
    { name: "additional_insurance", price: 1000, beneficiary: "drivy" }
  ]

  class << self
    def all
      options = DatabaseReader.new('input.json').read.options
      options.map { |option_struct| Option.new(option_struct) }
    end

    def find_all_by_rental(rental)
      all.select { |option| option.rental.id == rental.id }
    end
  end

  def initialize(option_struct)
    @id = option_struct.id
    @rental = Rental.find(option_struct.rental_id)
    @type = option_struct.type
    @price_per_day = TYPE.find { |hash| hash.dig(:name) == type }.dig(:price)
    @beneficiary = TYPE.find { |hash| hash.dig(:name) == type }.dig(:beneficiary)
    validate
  end

  def price
    price_per_day * rental.duration
  end

  private

  def validate
    raise ArgumentError, "Option ID missing" unless id.is_a?(Integer)
    raise ArgumentError, "Option #{id} must be linked to a correct rental" unless rental.is_a?(Rental)
    raise ArgumentError, "Type must be gps, baby_seat or additional_insurance" unless TYPE.map { |hash| hash.dig(:name) }.include?(type)
    raise ArgumentError, "Price per day must a positive integer" unless price_per_day.is_a?(Integer) && price_per_day >= 0
    raise ArgumentError, "Beneficiary must be driver, owner, insurance, assistance or drivy" unless MoneyMovement::TYPE.include?(beneficiary)
  end
end
