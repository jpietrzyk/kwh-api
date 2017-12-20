require 'rails_helper'

describe GetConsumptionDataService do
  describe '#call' do
    include_context :xml_content
    let(:start_date) { '01-12-2017' }
    let(:end_date) { '05-12-2017' }
    let(:group_by) { 'day' }
    let(:price) { 10 }
    context 'with all and valid arguments' do
      it 'return success result' do
        expect(described_class.new(start_date: start_date, end_date: end_date,
                                   group_by: group_by,
                                   price: price).call.success?).to be true
      end
    end
    context 'with valid dates' do
      let(:group_by) { nil }
      let(:price) { nil }
      it 'return success result' do
        expect(described_class.new(start_date: start_date, end_date: end_date,
                                   group_by: group_by,
                                   price: price).call.success?).to be true
      end
    end
    context 'with invalid date' do
      let(:start_date) { '30-30-9999' }
      it 'return failure result' do
        expect(described_class.new(start_date: start_date, end_date: end_date,
                                   group_by: group_by,
                                   price: price).call.success?).to be false
      end
    end
    context 'without arguments' do
      it 'raise ArgumentError' do
        expect { described_class.new.call }.to raise_error ArgumentError
      end
    end
  end
end
