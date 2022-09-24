class ReportMaker
  attr_accessor :job_repo, :user_repo

  def initialize(job_repo, user_repo, offer_counter, amount_counter)
    @job_repo = job_repo
    @user_repo = user_repo
    @offer_counter = offer_counter
    @amount_counter = amount_counter
  end

  def collect_items
    items = []
    return items if @user_repo.users.empty?

    @user_repo.users.each do |user|
      user.job_offers = @job_repo.find_by_owner(user)
      item = {
        "user_email": user.email,
        "subscription": user.subscription.name,
        "active_offers_count": @offer_counter.count_active_by_id(user.id),
        "amount_to_pay": user.subscription.amount_to_pay(user.job_offers)
      }
      items.push(item)
    end
    items
  end

  def make_report
    items = collect_items
    {
      items: items,
      total_amount: @amount_counter.total_amount(items),
      total_active_offers: @offer_counter.count_active
    }
  end
end
