class WordController < ApplicationController
  def game
    @grid = generate_grid(10)

  end

  def score
    @attempt = params[:query]
    @grid = params[:grid]
    @start_time = DateTime.parse(params[:start_time])
    @end_time = Time.now
    @result = run_game(@attempt, @grid, @start_time, @end_time)
  end

  private

  def generate_grid(grid_size)
    Array.new(grid_size) { ('A'..'Z').to_a.sample }
  end

  def english_words?(attempt)
    url = "https://wagon-dictionary.herokuapp.com/#{attempt}"
    dictionnary = open(url).read
    correct_word = JSON.parse(dictionnary)
    return correct_word['found']
  end

  def inside_grid?(attempt, grid)
    p attempt.split(//)
    return attempt.upcase.split(//).all? { |letter| attempt.upcase.count(letter) <= grid.count(letter) }
  end

  def run_game(attempt, grid, start_time, end_time)
    result = { time: (end_time - start_time).to_i, score: 0, message: "salut" }
    if english_words?(attempt) == false
      result[:message] = "not an english word"
    elsif inside_grid?(attempt, grid) == false
      result[:message] = "not in the grid"
    else
      result[:message] = "Well done"
      result[:score] = (1 / result[:time]) * attempt.length
    end
    return result
  end

end
