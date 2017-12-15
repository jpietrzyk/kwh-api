require 'rails_helper'

describe 'External API request' do
  it 'Fetches energy xml data' do
    uri = URI('https://finestmedia.ee/kwh/')

    response = Net::HTTP.get(uri)

    expect(response).to be_an_instance_of(String)
  end
end
