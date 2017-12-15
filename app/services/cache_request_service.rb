require 'redis'
require "json"

# This is first layer cache writter. It saves request url as a key, and
# parsed and validated result as a value, so when request is in cache
# we don't need parse raw xml, and validate responsed data
class CacheRequestService

  def initialize(request:, result:)
    @request = request
    @result = result
    @redis = Redis.new
  end

  def call
    redis.set(request, result.to_json)
    Result.new(status: :success,
               data: request,
               message: 'Request cached SUCCESS')

  rescue StandardError => e
    Result.new(status: :failure,
               data: request,
               message: "Caching failed: #{e.message}
                         See the errors for more information",
               errors: [e])
  end

  private

  attr_reader :request, :result, :redis
end
