require 'rails_helper'

describe ParseFeedService do
  include_context :xml_content
  describe '#call' do
    context 'Valid arguments' do
      it 'parse xml string' do
        expect(described_class.new(feed: xml_content).call.success?).to be true
      end
      it 'return result with parsed xml' do
        expect(described_class.new(feed: xml_content)
                              .call.data.class.name).to eq 'Ox::Document'
      end
    end
    context 'Invalid xml' do
      it 'return failed response' do
        expect(described_class.new(feed: 'malformed-xml')
                              .call.success?).to be false
      end
    end
    context 'Invalid parameters provided' do
      it 'raise ArgumentError' do
        expect { described_class.new.call }.to raise_error ArgumentError
      end
    end
  end
end
