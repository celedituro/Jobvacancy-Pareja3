require 'spec_helper'

describe OfferCounter do
  describe 'count_active' do
    it 'should be 0 when no active offers' do
      repo = instance_double('offer_repo', all_active: [])
      counter = described_class.new(repo)
      expect(counter.count_active).to eq 0
    end

    it 'should be 1 when one active offers' do
      job = JobOffer.new(title: 'title', is_active: true, user_id: 1)
      repo = instance_double('offer_repo', all_active: [job])
      counter = described_class.new(repo)
      expect(counter.count_active).to eq 1
    end

    it 'should be 1 when one inactive offers' do
      job = JobOffer.new(title: 'title', is_active: false, user_id: 1)
      repo = instance_double('offer_repo', all_active: [job])
      counter = described_class.new(repo)
      expect(counter.count_active).to eq 1
    end
  end
end
