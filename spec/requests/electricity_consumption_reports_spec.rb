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
    # TODO: Add params validation and specs for invalid params
    # (end_date < start_date and start_date < 2.years.ago)
    context 'when params are valid' do
      before do
        post '/electricity_consumption_reports', params: valid_params
      end

      it 'returns the consumption records for requested time range' do
        expect(json).not_to be_empty
        expect(json.first['time'].to_date).to eq(valid_params[:start_date]
                                                 .to_date)
        expect(json.last['time'].to_date).to eq(valid_params[:end_date]
                                                 .to_date)
      end
    end
  end
end
