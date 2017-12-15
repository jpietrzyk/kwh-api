require 'rails_helper'

describe ParseFeedService do
  include_context :xml_content
  describe '#call' do
    it 'parse xml string' do
      expect(described_class.new(feed: xml_content).call.success?).to be true
    end
    it 'return result with parsed xml' do
      expect(described_class.new(feed: xml_content).call.data.class.name).to eq 'Ox::Document'
    end
  end
end
