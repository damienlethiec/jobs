class RentalDay
  attr_reader :rental_day_number, :car

  def initialize(rental_day_number, car)
    @rental_day_number = rental_day_number
    @car = car
    validate
  end

  def discount
    case rental_day_number
    when 1
      0
    when 2..4
      0.1
    when 4..10
      0.3
    else
      0.5
    end
  end

  def price
    (car.price_per_day * (1 - discount)).to_i
  end

  private

  def validate
    raise ArgumentError, "Rental Day Number must be an integer greater that 1" unless rental_day_number.is_a?(Integer) && rental_day_number >= 1
    raise ArgumentError, "Rental day must be linked to a correct car" unless car.is_a?(Car)
  end
end
