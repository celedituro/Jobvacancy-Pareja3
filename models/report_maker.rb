class ReportMaker
  attr_accessor :job_repo, :user_repo

  def initialize(job_repo, user_repo)
    @job_repo = job_repo
    @user_repo = user_repo
    @offer_counter = OfferCounter.new(job_repo)
  end

  def collect_items
    items = []
    return items if @user_repo.users.empty?

    @user_repo.users.each do |user|
      user.job_offers = @job_repo.find_by_owner(user)
      item = {
        "user_email": user.email,
        "subscription": user.subscription.name,
        "active_offers_count": @offer_counter.count_active,
        "amount_to_pay": user.subscription.amount_to_pay(user.job_offers)
      }
      items.push(item)
    end
    items
  end

  def make_report
    {
      items: collect_items,
      total_amount: 0.0,
      total_active_offers: 0
    }
  end
end
