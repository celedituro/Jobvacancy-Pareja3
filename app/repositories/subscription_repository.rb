class SubscriptionRepository
  def initialize
    @subscriptions = {
      'on-demand' => OnDemandFactory.new,
      'professional' => ProfessionalFactory.new,
      'corporate' => CorporateFactory.new
    }
  end

  def create_by_subscription(subscription_name)
    return @subscriptions.fetch(subscription_name).create if @subscriptions.key?(subscription_name)
  end
end
