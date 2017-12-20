module Validate
  class ElectricityConsumption
    include ActiveModel::Validations

    attr_accessor :start_date, :end_date, :price, :group_by

    validates :start_date, :end_date,
              presence: true,
              format: { with: /\A\d\d-\d\d-\d\d\d\d\z/,
                        message: 'only date in dd-mm-yyyy format' }
    validates :group_by, inclusion: { in: %w[day week month],
                                      message: '%{value} is not a valid type' }
    validates :price, numericality: true

    def initialize(params = ActionController::Parameters.new)
      @start_date = params[:start_date]
      @end_date = params[:end_date]
      @group_by = params[:group_by]
      @price = params[:price]
      params.permit(:start_date, :end_date, :group_by, :price)
    end
  end
end
