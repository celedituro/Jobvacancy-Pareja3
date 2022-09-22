class Subscription
  def amount_to_pay(_offers)
    raise 'Should be implemented by subclass'
  end
end

class OnDemandSubscription < Subscription
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

class ProfessionalSubscription < Subscription
  PRICE = 30.0
  NAME = 'professional'.freeze

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
