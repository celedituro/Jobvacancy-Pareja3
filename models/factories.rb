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
