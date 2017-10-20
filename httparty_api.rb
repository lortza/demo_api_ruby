require 'dotenv/load'

require 'httparty'
require 'pp'
require "awesome_print"
require 'json'

API_KEY = ENV['API_KEY']

base_url = "https://api.nytimes.com/svc/mostpopular/v2/mostshared/all-sections/1.json"

url = "#{base_url}?api-key=#{API_KEY}"


response = HTTParty.get(url)

# save response to a file
File.open("data/temp.json","w") do |f|
  f.write(response['results'].to_json)
end

# access that saved response again
my_response = JSON.parse(File.read("data/temp.json"))
my_response.each do |story|
  p story['title']
  p story['url']
  p story['byline']
  p story['published_date']
  puts ''
end

# OR output response to console
response['results'].each do |story|
  p story['title']
  p story['url']
  p story['byline']
  p story['published_date']
  puts ''
end

