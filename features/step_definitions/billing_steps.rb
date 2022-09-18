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

Then('the total amount is {float}') do |_expected_total_amount|
  pending
end

Given('a user {string} with {string} subscription') do |user_email, _subscription_type|
  @user = User.create(user_email, user_email, 'somePassword!')
  @subscription = OnDemandSubscription.new
  @user.subscribe_to(@subscription)
  UserRepository.new.save(@user)
end

Given('{int} active offers') do |offer_count|
  JobOfferRepository.new.delete_all
  (0..offer_count).each do |_i|
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

Then('the total active offers are {int}') do |_expected_offer_count|
  pending # Write code here that turns the phrase above into concrete actions
end

Given('another user {string} with {string} susbcription') do |_user_email, _subscription_type|
  pending # Write code here that turns the phrase above into concrete actions
end

Given('the user {string} has {int} active offers') do |user_email, active_offer_count|
  @user = UserRepository.new.find_by_email(user_email)
  (1..active_offer_count).each do |i|
    @job_offer = JobOffer.new(title: "title_#{i}", is_active: true, user_id: @user.id)
    @job_offer.owner = @user
    JobOfferRepository.new.save @job_offer
  end
end

Given('{int} inactive offers') do |_inactive_offer_count|
  pending # Write code here that turns the phrase above into concrete actions
end

Then('the billing for this user is {float}') do |_expected_amount|
  pending # Write code here that turns the phrase above into concrete actions
end

Given('the user {string}') do |_user_email|
  pending # Write code here that turns the phrase above into concrete actions
end

Given('another user with {string} susbcription') do |_subscription_type|
  pending # Write code here that turns the phrase above into concrete actions
end

Then('the amount to pay for the user {string} is {float}.') do |_user_email, _expected_amount|
  pending # Write code here that turns the phrase above into concrete actions
end
