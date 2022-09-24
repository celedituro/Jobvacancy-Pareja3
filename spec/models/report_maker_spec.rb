require 'spec_helper'

def mock_functions(job_repo, user, job_offers)
  allow(job_repo).to receive(:find_by_owner).with(user).and_return(job_offers)
  allow(job_repo).to receive(:all_active_by_id).with(user.id).and_return(job_offers)
  job_repo
end

def mock_multiple_job_offers_repo(user, num_jobs)
  job_repo = instance_double('offer_repo', all_active: [])
  num_jobs.times { job_repo.all_active.push(JobOffer.new(title: 't', is_active: true, user_id: user.id)) }
  mock_functions(job_repo, user, job_repo.all_active)
end

def mock_multiple_users(num_users, sub_type)
  user_repo = instance_double('user_repo', users: [])
  num_users.times do |user|
    user_repo.users.push(User.new(id: user, email: "user_#{user}@gmail.com", subscription: sub_type))
  end
  user_repo
end

def mock_multiple_users_multiple_subs(num_users, sub_types)
  user_repo = instance_double('user_repo', users: [])
  sub_types.length.times do |type|
    num_users.times do |user|
      user_repo.users.push(User.new(id: user, email: "user_#{user}@gmail.com", subscription: sub_types[type]))
    end
  end
  user_repo
end

def mock_multiple_job_offers_repo_from_users(num_jobs, users)
  job_repo = instance_double('offer_repo', all_active: [])
  users.each do |user|
    job_offers = []
    num_jobs.times do
      job = JobOffer.new(title: 't', is_active: true, user_id: user.id)
      job_repo.all_active.push(job)
      job_offers.push(job)
    end
    job_repo = mock_functions(job_repo, user, job_offers)
  end
  job_repo
end

describe ReportMaker do
  describe 'make_report' do
    it 'should have an empty item list when no users' do
      job_repo = instance_double('offer_repo', all_active: [])
      user_repo = instance_double('user_repo', users: [])
      report_maker = described_class.new(job_repo, user_repo, OfferCounter.new(job_repo), AmountCounter.new)

      report = report_maker.make_report
      expect(report.fetch(:items).length).to eq 0
    end

    it 'should have a total_amount of 0.0 when no users' do
      job_repo = instance_double('offer_repo', all_active: [])
      user_repo = instance_double('user_repo', users: [])
      report_maker = described_class.new(job_repo, user_repo, OfferCounter.new(job_repo), AmountCounter.new)

      report = report_maker.make_report
      expect(report.fetch(:total_amount)).to eq 0.0
    end

    it 'should have a total_active_offers of 0 when no users' do
      job_repo = instance_double('offer_repo', all_active: [])
      user_repo = instance_double('user_repo', users: [])
      report_maker = described_class.new(job_repo, user_repo, OfferCounter.new(job_repo), AmountCounter.new)

      report = report_maker.make_report
      expect(report.fetch(:total_active_offers)).to eq 0
    end

    it 'should have 1 item list having 1 user' do
      user = User.new(id: 1, email: 'pepito@gmail.com')
      user_repo = instance_double('user_repo', users: [user])
      job_repo = mock_multiple_job_offers_repo(user, 1)
      report_maker = described_class.new(job_repo, user_repo, OfferCounter.new(job_repo), AmountCounter.new)

      expect(report_maker.make_report.fetch(:items).length).to eq 1
    end

    it 'should have 1 active_offers_count having 1 active offer' do
      user = User.new(id: 1, email: 'pepito@gmail.com')
      user_repo = instance_double('user_repo', users: [user])
      job_repo = mock_multiple_job_offers_repo(user, 1)
      report_maker = described_class.new(job_repo, user_repo, OfferCounter.new(job_repo), AmountCounter.new)

      expect(report_maker.make_report.fetch(:items)[0].fetch(:active_offers_count)).to eq 1
    end

    it 'should pay 10.0 having one active offer with on-demand subscription user' do
      user = User.new(id: 1, email: 'pepito@gmail.com')
      user_repo = instance_double('user_repo', users: [user])
      job_repo = mock_multiple_job_offers_repo(user, 1)
      report_maker = described_class.new(job_repo, user_repo, OfferCounter.new(job_repo), AmountCounter.new)

      expect(report_maker.make_report.fetch(:items)[0].fetch(:amount_to_pay)).to eq 10.0
    end

    it 'should have 4 total_active_offers having 4 active offers' do
      user = User.new(id: 1, email: 'pepito@gmail.com')
      user_repo = instance_double('user_repo', users: [user])
      job_repo = mock_multiple_job_offers_repo(user, 4)
      report_maker = described_class.new(job_repo, user_repo, OfferCounter.new(job_repo), AmountCounter.new)

      expect(report_maker.make_report.fetch(:total_active_offers)).to eq 4
    end

    it 'should have a total_amount of 40.0 with 4 active offers on-demand sub' do
      user = User.new(id: 1, email: 'pepito@gmail.com')
      user_repo = instance_double('user_repo', users: [user])
      job_repo = mock_multiple_job_offers_repo(user, 4)
      report_maker = described_class.new(job_repo, user_repo, OfferCounter.new(job_repo), AmountCounter.new)

      expect(report_maker.make_report.fetch(:total_amount)).to eq 40.0
    end

    it 'should pay 30.0 having 1 active offer with professional subscription' do
      user = User.new(id: 1, email: 'pepito@gmail.com', subscription: 'professional')
      user_repo = instance_double('user_repo', users: [user])
      job_repo = mock_multiple_job_offers_repo(user, 1)
      report_maker = described_class.new(job_repo, user_repo, OfferCounter.new(job_repo), AmountCounter.new)

      expect(report_maker.make_report.fetch(:items)[0].fetch(:amount_to_pay)).to eq 30.0
    end

    it 'should pay 80.0 having 1 active offer with corporate subscription' do
      user = User.new(id: 1, email: 'pepito@gmail.com', subscription: 'corporate')
      user_repo = instance_double('user_repo', users: [user])
      job_repo = mock_multiple_job_offers_repo(user, 1)
      report_maker = described_class.new(job_repo, user_repo, OfferCounter.new(job_repo), AmountCounter.new)

      expect(report_maker.make_report.fetch(:items)[0].fetch(:amount_to_pay)).to eq 80.0
    end

    it 'should have a total_amout of 30.0 with three on-demand subs' do
      users_repo = mock_multiple_users(3, 'on-demand')
      offer_repo = mock_multiple_job_offers_repo_from_users(1, users_repo.users)
      report_maker = described_class.new(offer_repo, users_repo, OfferCounter.new(offer_repo), AmountCounter.new)

      expect(report_maker.make_report.fetch(:total_amount)).to eq 30.0
    end

    it 'should have 4 total_active_offers having 4 users with 1 active offer each' do
      users_repo = mock_multiple_users(4, 'on-demand')
      offer_repo = mock_multiple_job_offers_repo_from_users(1, users_repo.users)
      report_maker = described_class.new(offer_repo, users_repo, OfferCounter.new(offer_repo), AmountCounter.new)

      expect(report_maker.make_report.fetch(:total_active_offers)).to eq 4
    end

    it 'should have a total_amout of 110.0 with three on-demand subs' do
      users_repo = mock_multiple_users_multiple_subs(1, %w[professional corporative])
      offer_repo = mock_multiple_job_offers_repo_from_users(2, users_repo.users)
      report_maker = described_class.new(offer_repo, users_repo, OfferCounter.new(offer_repo), AmountCounter.new)

      expect(report_maker.make_report.fetch(:total_amount)).to eq 110.0
    end

    it 'should have 3 active_offers_count for pepito@gmail.com user' do
      users_repo = mock_multiple_users(2, 'on-demand')
      offer_repo = mock_multiple_job_offers_repo_from_users(3, users_repo.users)
      report_maker = described_class.new(offer_repo, users_repo, OfferCounter.new(offer_repo), AmountCounter.new)

      expect(report_maker.make_report.fetch(:items)[0].fetch(:active_offers_count)).to eq 3
    end
  end
end
