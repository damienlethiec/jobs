require 'date'
require_relative '../services/database_reader.rb'
require_relative '../models/car.rb'
require_relative '../models/rental_day.rb'
require_relative '../models/rental_fees.rb'


class Rental
  attr_reader :id, :car, :start_date, :end_date, :distance

  class << self
    def all
      rentals = DatabaseReader.new('input.json').read.rentals
      rentals.map { |rental_struct| Rental.new(rental_struct) }
    end

    def to_output_hash
      { rentals: all.map { |rental| rental.price_hash } }
    end
  end

  def initialize(rental_struct)
    @id = rental_struct.id
    @car = Car.find(rental_struct.car_id)
    @start_date = rental_struct.start_date ? Date.parse(rental_struct.start_date) : nil
    @end_date = rental_struct.start_date ? Date.parse(rental_struct.end_date) : nil
    @distance = rental_struct.distance
    validate
  end

  def total_days
    (end_date - start_date).to_i + 1
  end

  def rental_days
    total_days.times.with_object([]) do |day_number, rental_days|
      rental_days << RentalDay.new(day_number + 1, car)
    end
  end

  def time_price
    rental_days.sum(&:price)
  end

  def distance_price
    distance * car.price_per_km
  end

  def price
    @price ||= time_price + distance_price
  end

  def price_hash
    {
      id: id,
      price: price,
      commission: RentalFees.new(self).to_hash
    }
  end

  private

  def validate
    raise ArgumentError, "Rental ID missing" unless id.is_a?(Integer)
    raise ArgumentError, "Rental #{id} must be linked to a correct car" unless car.is_a?(Car)
    raise ArgumentError, "Start Date must be a date (rental #{id})" unless start_date.is_a?(Date)
    raise ArgumentError, "End Date must be a date (rental #{id})" unless start_date.is_a?(Date)
    raise ArgumentError, "Start Date must be before End Date (rental #{id})" unless start_date <= end_date
    raise ArgumentError, "Distance must be an integer (rental #{id})" unless distance.is_a?(Integer)
  end
end
