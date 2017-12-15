# Fetches xml data from our fetch url
# Use it for fetch new-not-cached data only
class FetchFeedService
  include HTTParty
  base_uri ENV['FETCH_URL']

  def initialize(start_date:, end_date:)
    @options = { query: { start: start_date, end: end_date } }
    @content = nil
  end

  def call
    Result.new(status: :success,
               data: fetch_data,
               message: 'Fetch raw data SUCCESS!')

  # TODO: Look at Ox errors, and catch only Net::HTTP errors,
  # not all std errors!
  rescue StandardError => e
    Result.new(status: :failure,
               data: options,
               message: "Feed fetch fail with message: #{e.message}",
               errors: [e])
  end

  private

  attr_reader :options

  def fetch_data
    self.class.get("/", @options).body
  end
end
