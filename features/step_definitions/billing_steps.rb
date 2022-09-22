require 'json'

Given('user {string} with an on-demand susbcription') do |user_email|
  @user = User.create(user_email, user_email, 'somePassword!')
  UserRepository.new.save(@user)
end

Given('there are no offers at all') do
  JobOfferRepository.new.delete_all
end

When('I get the billing report') do
  visit 'reports/billing'
  @report_as_json = JSON.parse(page.body)
end

Then('the total active offers is {int}') do |expected_active_offers|
  expect(@report_as_json['total_active_offers']).to eq expected_active_offers
end

Then('the total amount is {float}') do |expected_total_amount|
  expect(@report_as_json['total_amount']).to eq expected_total_amount
end

Given('a user {string} with {string} subscription') do |user_email, subscription_type|
  UserRepository.new.delete_all
  @user = User.create(user_email, user_email, 'somePassword!')
  @subscription = SubscriptionRepository.new.create_by_subscription(subscription_type)
  @user.subscription = @subscription
  UserRepository.new.save(@user)
end

Given('{int} active offers') do |offer_count|
  (1..offer_count).each do |_i|
    @job_offer = JobOffer.new(title: 'title', is_active: true)
    @job_offer.owner = UserRepository.new.first
    JobOfferRepository.new.save @job_offer
  end
end

Then('the amount to pay for the user {string} is {float}') do |user_email, expected_amount|
  @report_as_json['items'].each do |user|
    expect(user.fetch('amount_to_pay')).to eq expected_amount if user.fetch('user_email') == user_email
  end
end

Then('the total active offers are {int}') do |expected_offer_count|
  expect(@report_as_json['total_active_offers']).to eq expected_offer_count
end

Given('another user {string} with {string} susbcription') do |user_email, subscription_type|
  @another_user = User.create(user_email, user_email, 'somePassword!')
  @subscription = SubscriptionRepository.new.create_by_subscription(subscription_type)
  @another_user.subscription = @subscription
  UserRepository.new.save(@another_user)
end

Given('the user {string} has {int} active offers') do |user_email, active_offer_count|
  @user = UserRepository.new.find_by_email(user_email)
  (1..active_offer_count).each do |i|
    @job_offer = JobOffer.new(title: "title_#{i}", is_active: true, user_id: @user.id)
    @job_offer.owner = @user
    JobOfferRepository.new.save @job_offer
  end
end

Given('{int} inactive offers') do |inactive_offer_count|
  (1..inactive_offer_count).each do |i|
    @job_offer = JobOffer.new(title: "inactive_#{i}", is_active: false)
    @job_offer.owner = UserRepository.new.first
    JobOfferRepository.new.save @job_offer
  end
end

Then('the billing for this user is {float}') do |expected_amount|
  @user = UserRepository.new.first
  @report_as_json['items'].each do |user|
    expect(user.fetch('amount_to_pay')).to eq expected_amount if user.fetch('user_email') == @user.email
  end
end

Given('the user {string}') do |user_email|
  @user = UserRepository.new.find_by_email(user_email)
end

Given('another user with {string} susbcription') do |_subscription_type|
  @other_user = User.create('pepe@hotmail.com', 'pepe@hotmail.com', 'somePassword!')
  @other_subscription = OnDemandSubscription.new
  @other_user.subscription = @other_subscription
  UserRepository.new.save(@other_user)
end

Then('the amount to pay for the user {string} is {float}.') do |user_email, expected_amount|
  @report_as_json['items'].each do |user|
    expect(user.fetch('amount_to_pay')).to eq expected_amount if user.fetch('user_email') == user_email
  end
end
