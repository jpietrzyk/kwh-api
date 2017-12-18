module Validate
  class ElectricityConsumptionReport
    include ActiveModel::Validations

    attr_accessor :start_date, :end_date

    validates :start_date, :end_date,
              presence: true,
              format: { with: /\A\d\d-\d\d-\d\d\d\d\z/,
                        message: 'only date in dd-mm-yyyy format' }

    def initialize(params = ActionController::Parameters.new)
      @start_date = params[:start_date]
      @end_date = params[:end_date]
      params.permit(:start_date, :end_date)
    end
  end
end
