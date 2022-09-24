class AmountCounter
  def total_amount(items)
    total = 0.0
    items.map { |item| total += item.fetch(:amount_to_pay) }
    total
  end
end
