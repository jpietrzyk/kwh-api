class ElectricityConsumptionReportsController < ApplicationController
  def create
    result = GetKwhService.new(start_time: params[:start_time],
                               end_time: params[:end_time]).call

    json_response(result.data, :created)
  end
end
