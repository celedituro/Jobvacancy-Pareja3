require 'spec_helper'

def mock_multiple_job_offers_repo(user, number)
  job_repo = instance_double('offer_repo', all_active: [])
  number.times { job_repo.all_active.push(JobOffer.new(title: 't', is_active: true, user_id: 1)) }
  allow(job_repo).to receive(:find_by_owner).with(user).and_return(job_repo.all_active)
  job_repo
end

describe ReportMaker do
  describe 'make_report' do
    it 'should have an empty item list when no users' do
      job_repo = instance_double('offer_repo', all_active: [])
      user_repo = instance_double('user_repo', users: [])
      report_maker = described_class.new(job_repo, user_repo)

      report = report_maker.make_report
      expect(report.fetch(:items).length).to eq 0
    end

    it 'should have a total_amount of 0.0 when no users' do
      job_repo = instance_double('offer_repo', all_active: [])
      user_repo = instance_double('user_repo', users: [])
      report_maker = described_class.new(job_repo, user_repo)

      report = report_maker.make_report
      expect(report.fetch(:total_amount)).to eq 0.0
    end

    it 'should have a total_active_offers of 0 when no users' do
      job_repo = instance_double('offer_repo', all_active: [])
      user_repo = instance_double('user_repo', users: [])
      report_maker = described_class.new(job_repo, user_repo)

      report = report_maker.make_report
      expect(report.fetch(:total_active_offers)).to eq 0
    end

    it 'should have 1 item list having 1 user' do
      user = User.new(id: 1, email: 'pepito@gmail.com')
      user_repo = instance_double('user_repo', users: [user])
      report_maker = described_class.new(mock_multiple_job_offers_repo(user, 1), user_repo)

      expect(report_maker.make_report.fetch(:items).length).to eq 1
    end

    it 'should have 1 active_offers_count having 1 active offer' do
      user = User.new(id: 1, email: 'pepito@gmail.com')
      user_repo = instance_double('user_repo', users: [user])
      report_maker = described_class.new(mock_multiple_job_offers_repo(user, 1), user_repo)

      expect(report_maker.make_report.fetch(:items)[0].fetch(:active_offers_count)).to eq 1
    end

    it 'should pay 10.0 having one active offer with on-demand subscription user' do
      user = User.new(id: 1, email: 'pepito@gmail.com')
      user_repo = instance_double('user_repo', users: [user])
      report_maker = described_class.new(mock_multiple_job_offers_repo(user, 1), user_repo)

      expect(report_maker.make_report.fetch(:items)[0].fetch(:amount_to_pay)).to eq 10.0
    end

    it 'should have 4 active_offers_count having 4 active offers' do
      user = User.new(id: 1, email: 'pepito@gmail.com')
      user_repo = instance_double('user_repo', users: [user])
      report_maker = described_class.new(mock_multiple_job_offers_repo(user, 4), user_repo)

      expect(report_maker.make_report.fetch(:total_active_offers)).to eq 4
    end

    it 'should have a total_amount of 40.0 with 4 active offers on-demand sub' do
      user = User.new(id: 1, email: 'pepito@gmail.com')
      user_repo = instance_double('user_repo', users: [user])
      report_maker = described_class.new(mock_multiple_job_offers_repo(user, 4), user_repo)

      expect(report_maker.make_report.fetch(:total_amount)).to eq 40.0
    end

    it 'should pay 30.0 having 1 active offer with professional subscription' do
      user = User.new(id: 1, email: 'pepito@gmail.com', subscription: 'professional')
      user_repo = instance_double('user_repo', users: [user])
      report_maker = described_class.new(mock_multiple_job_offers_repo(user, 1), user_repo)

      expect(report_maker.make_report.fetch(:items)[0].fetch(:amount_to_pay)).to eq 30.0
    end

    xit 'should pay 80.0 having one active offer corporate subscription' do
      user = User.new(id: 1, email: 'pepito@gmail.com')
      user.subscription = CorporateSubscription.new
      mocks = mock(user)

      expect(described_class.new(mocks[0], mocks[1]).make_report.fetch(:items)[0].fetch(:amount_to_pay)).to eq 80.0
    end
  end
end
