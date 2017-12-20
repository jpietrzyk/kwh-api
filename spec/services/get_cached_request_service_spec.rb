require 'rails_helper'

describe GetCachedRequestService do
  include_context :xml_content
  describe '#call' do
    context 'Valid arguments' do
      let(:request) { 'foo' }
      it 'return success result' do
        expect(described_class.new(request: request)
                              .call.success?).to be true
      end
    end
    context 'Invalid parameters provided' do
      it 'raise ArgumentError' do
        expect { described_class.new.call }.to raise_error ArgumentError
      end
    end
  end
end
