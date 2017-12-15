require 'ox'

# Parse XML string using Ox gem parser and writer
class ParseFeedService
  def initialize(feed:)
    @raw_feed = feed
  end

  def call
    Result.new(status: :success,
               data: parse_feed,
               message: 'Parse feed xml with SUCCESS')

  rescue StandardError => e
    Result.new(status: :failure,
               data: raw_feed,
               message: "Xml parser fail with message: #{e.message}
                         See the errors for more information",
               errors: [e])
  end

  private

  attr_reader :raw_feed

  def parse_feed
    Ox.parse(raw_feed)
  end
end
