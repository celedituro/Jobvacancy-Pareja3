require 'spec_helper'

describe OnDemandSubscription do
  describe 'amount_to_pay' do
    it 'should be 0.0 when no active offers' do
      job_offers = []
      on_demand_sub = described_class.new
      expect(on_demand_sub.amount_to_pay(job_offers)).to eq 0.0
    end

    it 'should be 10.0 when one active offers' do
      job_offers = []
      job_offers.append(JobOffer.new(title: 'Programmer vacancy', is_active: true))
      on_demand_sub = described_class.new
      expect(on_demand_sub.amount_to_pay(job_offers)).to eq 10.0
    end
  end
end
