class RentalFees
  attr_reader :rental

  COMMISSION_RATIO = 0.3
  INSURANCE_COMMISSION_RATIO = 0.5
  DAILY_ASSISTANCE_FEES = 100

  def initialize(rental)
    @rental = rental
    validate
  end

  def to_hash
    {
      "insurance_fee": insurance_fee,
      "assistance_fee": assistance_fee,
      "drivy_fee": drivy_fee
    }
  end

  def total_commission_cost
    @total_commission_cost ||= (rental.price * COMMISSION_RATIO).to_i
  end

  def insurance_fee
    (total_commission_cost * INSURANCE_COMMISSION_RATIO).to_i
  end

  def assistance_fee
    rental.total_days * 100
  end

  def drivy_fee
    total_commission_cost - insurance_fee - assistance_fee
  end

  private

  def validate
    raise ArgumentError, "Rental fees must be linked to a correct rental" unless rental.is_a?(Rental)
  end
end
