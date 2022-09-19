class OnDemandSubscription
  PRICE = 10.0
  NAME = 'on-demand'.freeze

  def name
    NAME
  end

  def amount_to_pay(job_offers)
    amount = 0.0
    job_offers.each do |job_offer|
      amount += PRICE if job_offer.is_active
    end
    amount
  end
end
