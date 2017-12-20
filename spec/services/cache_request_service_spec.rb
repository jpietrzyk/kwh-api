require 'rails_helper'

describe CacheRequestService do
  describe '#call' do
    context 'Valid parameters provided' do
      let(:request) { 'foo' }
      let(:result) { 'bar' }
      it 'return success result' do
        expect(described_class.new(request: request, result: result)
                              .call.success?).to be true
      end
    end
    context 'Invalid parameters provided' do
      let(:request) { 'asdf' }
      it 'raise ArgumentError' do
        expect { described_class.new(request: request).call }.to(
          raise_error ArgumentError
        )
      end
    end
  end
end
