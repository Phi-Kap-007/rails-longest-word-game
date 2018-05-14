require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = ("a".."z").to_a
    @letters = @letters.sample(8).join(" ")
    @start_time = Time.now
  end

  def score
    end_time = Time.now
    @answer = params[:answer]
    @letters = params[:letters]
    @time = end_time - DateTime.parse(params[:time])
    @result = score_and_message(@answer, @letters, @time)
  end

  private

  def score_and_message(attempt, grid, time)
    if included?(attempt, grid)
      if english_word?(attempt)
        score = compute_score(attempt, time)
        [score, "well done"]
      else
        [0, "not an english word"]
      end
    else
      [0, "not in the grid"]
    end
  end

  def included?(guess, grid)
    guess.chars.all? { |letter| guess.count(letter) <= grid.count(letter) }
  end

  def english_word?(word)
    response = open("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)
    return json['found']
  end

  def compute_score(attempt, time_taken)
    time_taken > 60.0 ? 0 : attempt.size * (1.0 - time_taken / 60.0)
  end
end
