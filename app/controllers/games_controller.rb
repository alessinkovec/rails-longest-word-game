require 'nokogiri'
require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = (0...10).map { ('a'..'z').to_a[rand(26)] }
  end

  def score
    @try = {
      attempt: params[:attempt],
      token: params[:authenticity_token],
      letters: params[:letters],
      start_time: params[:start_time]
    }
    file = open("https://wagon-dictionary.herokuapp.com/#{@try[:attempt]}")
    result = JSON.parse(Nokogiri::HTML(file).search('p').text)
    return @try = { score: 0, message: "not an english word mofo" } unless result["found"]
    if result["found"]
      @try[:attempt].chars.each do |character|
        if @try[:letters].chars.include? character
          @try[:letters].chars.delete(character)
        else
          return @try = { score: 0, message: "not in the grid" }
        end
      end
    end
    return @try = {
      score: (@try[:attempt].length.to_i + (Time.now.to_i - @try[:start_time].to_i)),
      message: "Well done motha fucka! w00p w00p"
    }
  end
end


# The word can't be built out of the original grid
# = sorry but can't be built
# The word is valid according to the grid, but is not a valid English word
# = sorry, not an english word
# The word is valid according to the grid and is an English word
# = congrats, it's english, and it was built!



