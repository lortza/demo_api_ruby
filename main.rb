require_relative 'typhoeus_api'

# ***** Run script for examples *****

# Instantiate the API wrapper for the last 7 days of stories
nyt_api = NYT.new(7, :json)

# Start checking out our results!
# Most emailed authors:
nyt_api.most_emailed.each { |article| puts article[:byline][3..-1] }
puts "",""

# Most shared story titles:
nyt_api.most_shared.each { |article| puts article[:title] }
puts "",""

# Most viewed story:
puts nyt_api.most_viewed.inspect
