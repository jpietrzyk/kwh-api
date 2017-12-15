# Main service for fetching remote data
# It fetches, parses, and caches data using various sub-services
# It uses Waterfall gem for chain dependent sub-services
class GetKwhService
  include Waterfall

  def initialize(start_time: nil, end_time: nil)
    @start_time = start_time&.to_date || Date.today.midnight - 2.days
    @end_time = end_time&.to_date || @start_time + 1.day
    @data = []
  end

  def call
    check_cache
    # if result for our request is not cached we have to fetch date from
    # external API
    fetch_feed unless in_cache
    parse_feed unless in_cache
    build_data unless in_cache
    cache_request unless in_cache

    Result.new(status: :success,
               data: data,
               message: 'Report created SUCCESS')
  end


  private

  attr_accessor :fetch_result, :parse_result, :data, :in_cache
  attr_writer :feed_url
  attr_reader :start_time, :end_time

  def check_cache
    result = GetCachedRequestService.new(request: cache_key).call
    @data = result.data if result.success? && result.data
    @in_cache = true if result.success? && result.data
  end

  def cache_key
    "/?#{start_time}&#{end_time}"
  end

  def parse_time(time)
    time.strftime('%0d-%0m-%Y')
  end

  def parse_start_time
    @start_date ||= parse_time(start_time)
  end

  def parse_end_time
    @end_date ||= parse_time(end_time)
  end

  def fetch_feed
    @fetch_result = FetchFeedService.new(
      start_date: parse_start_time,
      end_date: parse_end_time
    ).call
  end

  def parse_feed
    @parse_result = ParseFeedService.new(feed: fetch_result.data).call
  end

  def build_data
    parse_result.data.locate(
      '*/ConsumptionHistory/HourConsumption'
    ).each do |node|
      next unless (start_time..end_time).cover? node.ts.to_datetime

      @data << {
        val: node.text,
        time: node.ts.to_datetime,
        org_time: node.ts
      }
    end
  end

  def cache_request
    CacheRequestService.new(request: cache_key, result: data).call
  end
end
