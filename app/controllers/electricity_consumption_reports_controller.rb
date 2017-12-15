class ElectricityConsumptionReportsController < ApplicationController
  def create
    result = GetKwhService.new.call
    json_response(result.data)
  end
end
