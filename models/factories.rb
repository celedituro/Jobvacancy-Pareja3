class Factory
  def create
    raise 'Method should be override by subclass'
  end
end

class OnDemandFactory < Factory
  def create
    OnDemandSubscription.new
  end
end

class ProfessionalFactory < Factory
  def create
    ProfessionalSubscription.new
  end
end

class CorporateFactory < Factory
  def create
    CorporateSubscription.new
  end
end
