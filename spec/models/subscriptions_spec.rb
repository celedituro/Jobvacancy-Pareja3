require 'spec_helper'

describe Subscription do
  describe OnDemandSubscription do
    describe 'amount_to_pay' do
      it 'should be 0.0 when no active offers' do
        job_offers = []
        on_demand_sub = described_class.new
        expect(on_demand_sub.amount_to_pay(job_offers)).to eq 0.0
      end

      it 'should be 0.0 when one inactive offers' do
        job_offers = []
        job_offers.append(JobOffer.new(title: 'Programmer vacancy', is_active: false))
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

  describe ProfessionalSubscription do
    describe 'amount_to_pay' do
      it 'should be 30.0 when no active offers' do
        job_offers = []
        professional_sub = described_class.new
        expect(professional_sub.amount_to_pay(job_offers)).to eq 30.0
      end

      it 'should be 30.0 when one inactive offers' do
        job_offers = []
        job_offers.append(JobOffer.new(title: 'Programmer vacancy', is_active: false))
        professional_sub = described_class.new
        expect(professional_sub.amount_to_pay(job_offers)).to eq 30.0
      end

      it 'should be 30.0 when one active offers' do
        job_offers = []
        job_offers.append(JobOffer.new(title: 'Programmer vacancy', is_active: true))
        professional_sub = described_class.new
        expect(professional_sub.amount_to_pay(job_offers)).to eq 30.0
      end
    end
  end

  describe CorporateSubscription do
    describe 'amount_to_pay' do
      it 'should be 80.0 when no active offers' do
        job_offers = []
        professional_sub = described_class.new
        expect(professional_sub.amount_to_pay(job_offers)).to eq 80.0
      end

      it 'should be 80.0 when one inactive offers' do
        job_offers = []
        job_offers.append(JobOffer.new(title: 'Programmer vacancy', is_active: false))
        professional_sub = described_class.new
        expect(professional_sub.amount_to_pay(job_offers)).to eq 80.0
      end

      it 'should be 80.0 when one active offers' do
        job_offers = []
        job_offers.append(JobOffer.new(title: 'Programmer vacancy', is_active: true))
        professional_sub = described_class.new
        expect(professional_sub.amount_to_pay(job_offers)).to eq 80.0
      end
    end
  end
end
