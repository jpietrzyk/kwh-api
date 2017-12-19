require 'redis'
require 'json'

# This is first layer cache writter. It saves request url as a key, and
# parsed and validated result as a value, so when request is in cache
# we don't need parse raw xml, and validate responsed data
class GetCachedRequestService
  def initialize(request:)
    @redis = Redis.new
    @request = request
    @data = nil
  end

  def call
    parse_data
    Result.new(status: :success,
               data: data,
               message: data ? 'Request found. SUCCESS' : 'Request not found. SUCCESS')
  rescue StandardError => e
    Result.new(status: :failure,
               data: request,
               message: "Getting from cache failed: #{e.message}
                         See the errors for more information",
               errors: [e])
  end

  private

  attr_accessor :request, :redis, :data

  def parse_data
    @data = JSON.parse(redis.get(request))
  end

  def clear_cache!
    redis.keys.each { |k| redis.del k }
  end
end
