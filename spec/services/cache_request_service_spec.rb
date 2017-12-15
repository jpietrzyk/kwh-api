require 'rails_helper'

describe CacheRequestService do
  include_context :xml_content
  describe '#call' do
    let(:request) { 'foo' }
    let(:result) { 'bar' }
    it 'return success result' do
      expect(described_class.new(request: request, result: result)
                            .call.success?).to be true
    end
  end
end
