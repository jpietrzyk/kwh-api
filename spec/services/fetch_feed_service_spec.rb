require 'rails_helper'

describe FetchFeedService do
  include_context :xml_content
  describe '#call' do
    context 'Valid arguments' do
      let(:start_date) { (Date.today - 3.days).strftime('%0d-%0m-%Y') }
      let(:end_date) { (Date.today - 2.day).strftime('%0d-%0m-%Y') }
      before do
        stub_request(:get, %r{/finestmedia.ee\/kwh/})
          .to_return(status: 200, body: xml_content, headers: {})
      end
      it 'return success result' do
        expect(described_class.new(start_date: start_date, end_date: end_date)
                              .call.success?).to be true
      end
      it 'return result with fetched xml string' do
        expect(described_class.new(start_date: start_date, end_date: end_date)
                              .call.data).to eq xml_content
      end
    end
  end
  context 'Invalid arguments provided' do
    it 'raise ArgumentError' do
      expect { described_class.new.call }.to raise_error ArgumentError
    end
  end
end
