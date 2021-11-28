class MoneyMovement
  attr_reader :rental, :type

  TYPE = %w[driver owner insurance assistance drivy]
  COMMISSION_RATIO = 0.3
  INSURANCE_COMMISSION_RATIO = 0.5
  DAILY_ASSISTANCE_FEES = 100

  def initialize(type, rental)
    @rental = rental
    @type = type
    validate
  end

  def amount
    @amount ||= send("#{type}_money_movement")
  rescue NoMethodError => e
    raise NoMethodError "No existing #{type}_money_movement method for MoneyMovement. If this type exists it needs to be created"
  end

  def absolute_amount
    amount.abs
  end

  def direction
    amount > 0 ? "credit" : "debit"
  end

  def to_hash
    {
      "who": type,
      "type": direction,
      "amount": absolute_amount
    }
  end

  private

  (TYPE - ["driver"]).each do |type|
    define_method("#{type}_options_profit") do
      rental.options.select { |option| option.beneficiary == type }.sum(&:price)
    end
  end

  def total_commission_cost
    @total_commission_cost ||= (rental.price_without_options * COMMISSION_RATIO).to_i
  end

  def insurance_money_movement
    (total_commission_cost * INSURANCE_COMMISSION_RATIO).to_i + insurance_options_profit
  end

  def assistance_money_movement
    rental.duration * 100 + assistance_options_profit
  end

  def drivy_money_movement
    total_commission_cost - insurance_money_movement - assistance_money_movement + drivy_options_profit
  end

  def driver_money_movement
    - rental.price
  end

  def owner_money_movement
    (rental.price_without_options * (1- COMMISSION_RATIO)).to_i + owner_options_profit
  end

  def validate
    raise ArgumentError, "Rental fees must be linked to a correct rental" unless rental.is_a?(Rental)
    raise ArgumentError, "Type must be driver, owner, insurance, assistance or drivy" unless TYPE.include?(type)
  end
end
