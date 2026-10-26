module MoneyHelper
  # All prices are integer euro cents: euros(6500) => "€65", euros(4550) => "€45.50".
  def euros(cents)
    number_to_currency(cents / 100.0, unit: "€", format: "%u%n", precision: (cents % 100).zero? ? 0 : 2)
  end
end
