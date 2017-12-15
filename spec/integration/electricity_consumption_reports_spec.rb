require 'swagger_helper'

describe 'Electricity Consumption Reports API' do
  path '/electricity_consumption_reports' do
    post 'Creates a report' do
      tags 'Reports'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :start_date,
                in: :query,
                required: true,
                type: :string,
                description: 'Report start date in dd-mm-yyyy format',
                format: :'date'
      parameter name: :end_date,
                in: :query,
                required: true,
                type: :string,
                description: 'Report end date in dd-mm-yyyy format',
                format: :'date'

      response '201', 'Report created' do
        let(:start_date) { '01-12-2017' }
        let(:end_date) { '05-12-2017' }
        run_test!
      end

      response '422', 'invalid request' do
        let(:start_date) { 'asdf' }
        run_test!
      end
    end
  end
end
