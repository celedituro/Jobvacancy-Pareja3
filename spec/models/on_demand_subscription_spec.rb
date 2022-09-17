require 'spec_helper'

describe OnDemandSubscription do
  describe 'amount_to_pay' do
    it 'should be 0 when no active offers' do
      job_offers = []
      on_demand_sub = described_class.new
      expect(on_demand_sub.amount_to_pay(job_offers)).to eq 0
    end
  end
end
