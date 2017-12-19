require 'rails_helper'

describe 'Electricity consumption API', type: :request do
  include_context :xml_content
  describe 'POST /electricity_consumption_reports' do
    let(:valid_params) do
      {
        start_date: '01-12-2017',
        end_date: '05-12-2017'
      }
    end
    before do
      stub_request(:get, %r{/finestmedia.ee\/kwh/})
        .to_return(status: 201, body: xml_content, headers: {})
    end

    context 'when params are empty' do
      before { get '/electricity_consumption' }

      it 'returns error' do
        expect(json).not_to be_empty
      end

      it 'returns status code 400' do
        expect(response).to have_http_status(400)
      end
    end

    context 'when params are invalid' do
      before { get '/electricity_consumption',
               params: {start_date: 'asdf' } }

      it 'returns error' do
        expect(json).not_to be_empty
      end

      it 'returns status code 400' do
        expect(response).to have_http_status(400)
      end
    end

  end
end
