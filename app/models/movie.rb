class Movie < ActiveRecord::Base
 def self.all_ratings
  #  allRatings = []
 #   Movie.all.each do |movie|
#	if(allRatings.find_index(movie.rating) == nil)
#	   allRatings.push(movie.rating)
  #      end
 #   end
#   return allRatings
  return %w(G PG PG-13 NC-17 R)
 end
end
