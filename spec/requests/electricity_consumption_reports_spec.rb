require 'rails_helper'

describe 'Electricity consumption API', type: :request do
  include_context :xml_content
  describe 'POST /electricity_consumption_reports' do
    before { post '/electricity_consumption_reports' }

    it 'returns the consumption records' do
      expect(json).not_to be_empty
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end
end
