# Main service for fetching remote data
# It fetches, parses, and caches data using various sub-services
# It uses Waterfall gem for chain dependent sub-services
class GetKwhService
  def initialize(start_date:, end_date:, group_by:, price:)
    @start_date = start_date
    @end_date = end_date
    @group_by = group_by || :day
    @price = price || 1.0
    @response_data = []
    @consumption_data = []
  end

  def call
    check_cache
    # if result for our request is not cached we have to fetch date from
    # external API
    fetch_feed unless in_cache
    parse_feed unless in_cache

    # we are caching parsed response with only 2 keys - start_date and end_date
    # because external api doesn't provide date grouping and price counting
    build_response_data unless in_cache
    cache_request unless in_cache

    build_consumption_data
    Result.new(status: :success,
               data: consumption_data,
               message: 'Report created SUCCESS')
  end

  private

  attr_accessor :fetch_result, :parse_result, :response_data, :in_cache,
                :consumption_data
  attr_writer :feed_url
  attr_reader :start_date, :end_date, :group_by, :price

  def check_cache
    result = GetCachedRequestService.new(request: cache_key).call
    @response_data = result.data if result.success? && result.data
    @in_cache = true if result.success? && result.data
  end

  def cache_key
    "/?#{start_date}&#{end_date}"
  end

  def parse_date(date)
    date.strftime('%0d-%0m-%Y')
  end

  def parse_start_date
    @start_date ||= parse_date(start_date)
  end

  def parse_end_date
    @end_date ||= parse_date(end_date)
  end

  def fetch_feed
    @fetch_result = FetchFeedService.new(
      start_date: parse_start_date,
      end_date: parse_end_date
    ).call
  end

  def parse_feed
    @parse_result = ParseFeedService.new(feed: fetch_result.data).call
  end

  def build_response_data
    parse_result.data.locate(
      '*/ConsumptionHistory/HourConsumption'
    ).each do |node|

      next unless (start_date..end_date).cover? node.ts.to_date

      date = node.ts.to_date

      @response_data << {
        val: node.text,
        date: date,
        org_date: node.ts,
        # for grouping
        week_gr: "#{date.year}_#{date.cweek}",
        month_gr: "#{date.year}_#{date.month}",
        day_gr: "#{date.year}_#{date.month}_#{date.day}"
      }
    end
  end

  def grouped_response
    response_data.group_by { |d| d["#{group_by}_gr".to_sym] }
  end

  def build_consumption_data
    grouped_response.each do |group, data|
      consumption = data.map { |h| h[:val].to_f }.reduce(:+)
      @consumption_data << {
        label: group.to_s,
        consumption: consumption,
        price: consumption * price
      }
    end
  end

  def cache_request
    CacheRequestService.new(request: cache_key, result: response_data).call
  end
end
