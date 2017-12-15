require 'rails_helper'

describe GetCachedRequestService do
  include_context :xml_content
  describe '#call' do
    let(:request) { 'foo' }
    it 'return success result' do
      expect(described_class.new(request: request)
                            .call.success?).to be true
    end
  end
end
