require 'spec_helper'

def mock_repositories
  job_repo = instance_double('offer_repo',
                             all_active_by_id: [JobOffer.new(title: 'Programmer vacancy', is_active: true, user_id: 1)])
  user_repo = instance_double('user_repo',
                              users: [User.new(id: 1, name: 'Pepe', email: 'pepito@gmail.com', password: '1234567')])
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
      job_repo =
        user_repo = instance_double('user_repo', users: [])
      report_maker = described_class.new(job_repo, user_repo)

      report = report_maker.make_report
      expect(report.fetch(:total_active_offers)).to eq 0
    end

    it 'should have one item list having one user' do
      repos = mock_repositories
      report_maker = described_class.new(repos[0], repos[1])

      report = report_maker.make_report
      expect(report.fetch(:items).length).to eq 1
    end
  end
end
