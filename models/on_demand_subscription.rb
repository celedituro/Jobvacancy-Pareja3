class OnDemandSubscription
  PRICE = 10

  def amount_to_pay(job_offers)
    amount = 0
    job_offers.each do |job_offer|
      amount += PRICE if job_offer.is_active == true
    end
    amount
  end
end
