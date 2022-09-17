require 'spec_helper'

describe ReportMaker do
  describe 'make_report' do
    it 'should have an empty item list when no users' do
      job_repo = instance_double('offer_repo', all_active: [])
      user_repo = instance_double('user_repo', users: [])
      report_maker = described_class.new(job_repo, user_repo)

      report = report_maker.make_report
      expect(report.fetch(:items).length).to eq 0
    end

    it 'should have a total_amount of 0.0 when any users' do
      job_repo = instance_double('offer_repo', all_active: [])
      user_repo = instance_double('user_repo', users: [])
      report_maker = described_class.new(job_repo, user_repo)

      report = report_maker.make_report
      expect(report.fetch(:total_amount)).to eq 0.0
    end
  end
end
