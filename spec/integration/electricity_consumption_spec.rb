require 'swagger_helper'

describe 'Electricity Consumption API' do
  path '/electricity_consumption' do
    include_context :xml_content
    get 'Gets consumption data' do
      tags 'Reports'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :start_date,
                in: :query,
                required: true,
                type: :string,
                description: 'Report start date in dd-mm-yyyy format',
                format: :date
      parameter name: :end_date,
                in: :query,
                required: true,
                type: :string,
                description: 'Report end date in dd-mm-yyyy format',
                format: :date

      response '200', 'ok' do
        let(:start_date) { '01-12-2017' }
        let(:end_date) { '05-12-2017' }

        before do
          stub_request(:get, %r{/finestmedia.ee\/kwh/})
            .to_return(status: 200, body: xml_content, headers: {})
        end

        run_test!
      end
    end
  end
end
