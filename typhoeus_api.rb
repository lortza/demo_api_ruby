require 'dotenv/load'

require 'typhoeus'
require 'json'

require 'pry'
require 'pp'

class NYT
  BASE_URI = "http://api.nytimes.com/svc/mostpopular/v2"
  API_KEY = ENV["API_KEY"]

  VALID_FORMATS = [:json]
  VALID_PERIODS = [1, 7, 30]

  def initialize(time_period, response_format)
    validate_time_period!(time_period)
    validate_format!(response_format)

    @time_period = time_period
    @format = response_format.to_s.downcase
  end

  # Convenience wrapper for most emailed stories
  def most_emailed(sections = "all-sections", num_articles = 5)
    response = send_request("mostemailed", sections)
    trim_response( response, num_articles )
  end

  # Convenience wrapper for most viewed stories
  def most_viewed(sections = "all-sections", num_articles = 5)
    response = send_request("mostviewed", sections)
    trim_response( response, num_articles )
  end

  # Convenience wrapper for most shared stories
  def most_shared(sections = "all-sections", num_articles = 5)
    response = send_request("mostshared", sections)
    trim_response( response, num_articles )
  end

  private

  # Construct and initiate the new request
  def send_request(share_type, sections)
    return unless share_type && sections

    # Build our URL
    uri = [ BASE_URI, share_type, sections, @time_period ].join("/") + "." + @format

    # Build the params
    params = { "api-key" => API_KEY }

    # Build the request
    request = Typhoeus::Request.new( uri, :method => :get, :params => params )

    # Send the request (and return the response)
    request.run
  end


  def validate_time_period!(time_period)
    unless VALID_PERIODS.include?(time_period)
      raise "Invalid time period"
    end
  end


  def validate_format!(response_format)
    unless VALID_FORMATS.include?(response_format)
      raise "Invalid response format"
    end
  end

  # Take a messy huge response object and synthesize
  # it into the elements we want
  def trim_response(response, num_articles)
    response_body = JSON.parse(response.response_body)
    results = response_body["results"][ 0...num_articles ]
    results.map do |article|
      {
        :url            =>  article["url"],
        :title          =>  article["title"],
        :abstract       =>  article["abstract"],
        :published_date =>  article["published_date"],
        :byline         =>  article["byline"],
      }
    end #map
  end #trim

end #NYT

