require 'swagger_helper'

describe 'Electricity Consumption API' do
  path '/electricity_consumption' do
    include_context :xml_content
    get 'Gets consumption data' do
      before do
        stub_request(:get, %r{/finestmedia.ee\/kwh/})
          .to_return(status: 200, body: xml_content, headers: {})
      end
      tags 'Reports'
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
      parameter name: :price,
                in: :query,
                required: false,
                type: :number,
                description: 'Cost of 1KwH',
                format: :float
      parameter name: :group_by,
                in: :query,
                type: :string,
                required: false,
                description: 'Grouping type, should be
                              \'day\', \'week\' or \'month\''

      response '200', 'when all params provided' do
        let(:start_date) { '01-12-2017' }
        let(:end_date) { '05-12-2017' }
        let(:price) { 20 }
        let(:grop_by) { 'day' }

        before do
          stub_request(:get, %r{/finestmedia.ee\/kwh/})
            .to_return(status: 200, body: xml_content, headers: {})
        end
        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data).to_not be_empty
        end
      end

      response '200', 'when only start and end parameters provided' do
        let(:start_date) { '01-12-2017' }
        let(:end_date) { '05-12-2017' }
        run_test!
      end

      response '400', 'when invalid parameters provided' do
        let(:start_date) { nil }
        let(:end_date) { nil }
        run_test!
      end

      response '400', 'when wrong date provided' do
        let(:start_date) { '30-30-9999' }
        let(:end_date) { '05-12-2017' }
      end
    end
  end
end
