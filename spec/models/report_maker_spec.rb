require 'spec_helper'

def mock
  user = User.new(id: 1, email: 'pepito@gmail.com')
  job = JobOffer.new(title: 'title', is_active: true, user_id: 1)
  job_repo = instance_double('offer_repo', all_active: [job])
  allow(job_repo).to receive(:find_by_owner).with(user).and_return([job])
  user_repo = instance_double('user_repo', users: [user])
  [job_repo, user_repo]
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

    it 'should have one item list having one user' do
      mocks = mock
      report_maker = described_class.new(mocks[0], mocks[1])

      report = report_maker.make_report
      expect(report.fetch(:items).length).to eq 1
    end

    it 'should have one item list having one active offer' do
      mocks = mock
      report_maker = described_class.new(mocks[0], mocks[1])

      report = report_maker.make_report
      expect(report.fetch(:items)[0].fetch(:active_offers_count)).to eq 1
    end

    it 'should pay $10 having one active offer on-demand subscription' do
      mocks = mock
      report_maker = described_class.new(mocks[0], mocks[1])

      report = report_maker.make_report
      expect(report.fetch(:items)[0].fetch(:amount_to_pay)).to eq 10.0
    end

    it 'should have 4 total active offers' do
      mocks = mock
      3.times { mocks[0].all_active.push(JobOffer.new(title: 't', is_active: true, user_id: 1)) }
      report_maker = described_class.new(mocks[0], mocks[1])

      report = report_maker.make_report
      expect(report.fetch(:total_active_offers)).to eq 4
    end
  end
end
