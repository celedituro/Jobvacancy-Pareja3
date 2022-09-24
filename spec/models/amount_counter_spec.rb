require 'spec_helper'

describe AmountCounter do
  describe 'total_amount' do
    it 'should be 0 when no items ' do
      items = []
      expect(described_class.new.total_amount(items)).to eq 0
    end

    it 'should be 10.0 when 1 on-demand active offer ' do
      items = [{
        amount_to_pay: 10.0
      }]
      expect(described_class.new.total_amount(items)).to eq 10.0
    end

    it 'should be 90.0 when 1 on-demand active offer and corporative sub' do
      items = [
        { amount_to_pay: 10.0 }, { amount_to_pay: 80.0 }
      ]
      expect(described_class.new.total_amount(items)).to eq 90.0
    end
  end
end
