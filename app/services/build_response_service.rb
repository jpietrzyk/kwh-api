# Response data builder
# Response has data structure that we can cache and use it later
class BuildResponseService
  def initialize(data:, start_date:, end_date:)
    @data = data
    @start_date = start_date
    @end_date = end_date
    @response_data = []
  end

  def call
    build_data
    Result.new(status: :success,
               data: @response_data,
               message: 'Build response SUCCESS')
  rescue StandardError => e
    Result.new(status: :failure,
               data: data,
               message: "Response building failed with error #{e.message}",
               errors: [e])
  end

  private

  attr_accessor :response_data
  attr_reader :data, :start_date, :end_date

  def build_data
    data.locate(
      '*/ConsumptionHistory/HourConsumption'
    ).each do |node|
      next unless (start_date..end_date).cover? node.ts.to_date
      date = node.ts.to_date
      @response_data << {
        'val' => node.text,
        'date' => date,
        'org_date' => node.ts,
        'week_gr' => "#{date.cweek}-#{date.year}",
        'month_gr' => "#{date.month}-#{date.year}",
        'day_gr' => "#{date.day}-#{date.month}-#{date.year}"
      }
    end
  end
end
