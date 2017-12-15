class ElectricityConsumptionReportsController < ApplicationController
  before_action :validate_params

  def create
    result = GetKwhService.new(start_date: params[:start_date].to_date,
                               end_date: params[:end_date].to_date).call

    json_response(result.data, :created)
  end

  ActionController::Parameters.action_on_unpermitted_parameters = :raise

  rescue_from(ActionController::UnpermittedParameters) do |pme|
    render json: { error: { unknown_parameters: pme.params } },
           status: :bad_request
  end

  rescue_from(ActiveModel::ValidationError) do |err|
    render json: { error: err }, status: :bad_request
  end

  private

  def validate_params
    report = Validate::ElectricityConsumptionReport.new(params)
    report.validate!
  end
end
