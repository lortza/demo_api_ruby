require 'dotenv/load'

require 'httparty'
require 'pp'
require "awesome_print"

API_KEY = ENV['API_KEY']

base_url = "https://api.nytimes.com/svc/mostpopular/v2/mostshared/all-sections/1.json"

url = "#{base_url}?api-key=#{API_KEY}"


response = HTTParty.get(url)

response['results'].each do |story|
  ap story['title']
  ap story['url']
  ap story['byline']
  ap story['published_date']
  puts ''
end