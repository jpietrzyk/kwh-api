# Main service for fetching remote data
# It fetches, parses, and caches data using various sub-services
# It uses Waterfall gem for chain dependent sub-services
class GetConsumptionDataService
  def initialize(start_date:, end_date:, group_by:, price:)
    @start_date = start_date
    @end_date = end_date
    @group_by = group_by || 'day'
    @price = price&.to_f
    @response_data = []
    @consumption_data = []
    @in_cache = false
  end

  def call
    check_cache
    unless in_cache
      fetch_feed
      parse_feed
      build_response_data
      cache_request
    end
    build_consumption_data
    Result.new(status: :success, data: consumption_data,
               message: 'Report created SUCCESS')
  rescue ServiceError => e
    Result.new(status: :failure, data: e,
               message: "Getting the electricity consumption data failed because of error: #{e.message}",
               errors: [e])
  end

  private

  attr_accessor :fetch_result, :parse_result, :response_data, :in_cache,
                :consumption_data
  attr_writer :feed_url
  attr_reader :start_date, :end_date, :group_by, :price, :parsed_start_date
              :parsed_end_date

  def check_cache
    result = GetCachedRequestService.new(request: cache_key).call
    raise ServiceError result.message if result.failure?

    @response_data = result.data if result.success? && result.data
    @in_cache = true if result.success? && result.data
  end

  def cache_key
    "/?#{start_date}&#{end_date}"
  end

  def parse_date(date)
    date.to_date.strftime('%0d-%0m-%Y')
  rescue ArgumentError => e
    raise ServiceError, 'Invalid date. Check date format.'
  end

  def parse_start_date
    @parsed_start_date ||= parse_date(start_date)
  end

  def parse_end_date
    @parsed_end_date ||= parse_date(end_date)
  end

  def fetch_feed
    @fetch_result = FetchFeedService.new(start_date: parse_start_date,
                                         end_date: parse_end_date).call
    raise ServiceError fetch_result.message if fetch_result.failure?
  end

  def parse_feed
    @parse_result = ParseFeedService.new(feed: fetch_result.data).call
    raise ServiceError parse_result.message if parse_result.failure?
  end

  def build_response_data
    result = BuildResponseService.new(data: parse_result.data,
                                      start_date: start_date.to_date,
                                      end_date: end_date.to_date).call
    raise ServiceError result.message if result.failure?
    @response_data = result.data
  end

  def cache_request
    result = CacheRequestService.new(request: cache_key,
                                     result: response_data).call
    raise ServiceError, result.message if result.failure?
  end

  def grouped_response
    response_data.group_by { |d| d["#{group_by}_gr"] }
  end

  def build_consumption_data
    grouped_response.each do |group, data|
      consumption = data.map { |h| h['val'].to_f }.reduce(:+).round(2)
      cost = price ? consumption * price : nil
      @consumption_data << {
        label: group.to_s,
        consumption_size: consumption,
        consumption_cost: cost
      }
    end
  end
end
