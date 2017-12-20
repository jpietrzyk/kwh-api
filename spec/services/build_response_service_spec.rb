require 'rails_helper'

describe BuildResponseService do
  describe '#call' do
    include_context :xml_content
    context 'with valid arguments' do
      let(:start_date) { '01-12-2017'.to_date }
      let(:end_date) { '05-12-2017'.to_date }
      it 'return success result' do
        expect(described_class.new(data: Ox.parse(xml_content),
                                   start_date: start_date,
                                   end_date: end_date).call.success?).to be true
      end
    end
    context 'with invalid arguments' do
      it 'raise ArgumentError' do
        expect { described_class.new.call }.to raise_error ArgumentError
      end
    end
  end
end
