class ElectricityConsumptionController < ApplicationController
  def show
    result = GetKwhService.new.call
    json_response(result.data)
  end
end
