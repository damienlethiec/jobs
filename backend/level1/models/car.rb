require_relative '../services/database_reader.rb'

class Car
  attr_reader :id, :price_per_day, :price_per_km

  class << self
    def all
      cars = DatabaseReader.new('input.json').read.cars
      cars.map { |car_struct| Car.new(car_struct) }
    end

    def find(id)
      all.find { |car| car.id == id }
    end
  end

  def initialize(car_struct)
    @id = car_struct.id
    @price_per_day = car_struct.price_per_day
    @price_per_km = car_struct.price_per_km
    validate
  end

  private

  def validate
    raise ArgumentError, "Car ID missing" unless id.is_a?(Integer)
    raise ArgumentError, "Price per day must be an integer (car #{id})" unless price_per_day.is_a?(Integer)
    raise ArgumentError, "Price per km must be an integer (car #{id})" unless price_per_km.is_a?(Integer)
  end
end
