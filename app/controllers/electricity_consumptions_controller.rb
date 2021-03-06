class ElectricityConsumptionsController < ApplicationController
  before_action :validate_params

  def show
    result = GetConsumptionDataService.new(start_date: params[:start_date],
                                           end_date: params[:end_date],
                                           group_by: params[:group_by],
                                           price: params[:price]).call

    if result.success?
      json_response(result.data, :ok)
    else
      json_response({ error: result.message }, :bad_request)
    end
  end

  # TODO: RSwag sends a lot of additional params
  # try to configure it to not do that, so we can validate
  # against unpermitted parameters
  # ActionController::Parameters.action_on_unpermitted_parameters = :raise

  rescue_from(ActionController::UnpermittedParameters) do |pme|
    render json: { error: { unknown_parameters: pme.params } },
           status: :bad_request
  end

  rescue_from(ActiveModel::ValidationError) do |err|
    render json: { error: err }, status: :bad_request
  end

  private

  def validate_params
    report = Validate::ElectricityConsumption.new(params)
    report.validate!
  end
end
