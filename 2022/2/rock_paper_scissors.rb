# rubocop:disable all
class Round
  Points = {
    loss: 0,
    draw: 3,
    win: 6
  }

  DecodeMap = {
    "A" => :rock,
    "B" => :paper,
    "C" => :scissors,
    "X" => :rock,
    "Y" => :paper,
    "Z" => :scissors,
  }

  ShapePoints = {
    rock: 1,
    paper: 2,
    scissors: 3,
  }

  WinLogic = {
    rock: :scissors,
    paper: :rock,
    scissors: :paper,
  }

  def initialize(they, me)
    @they = decode(they)
    @me = decode(me)
  end

  def score
    gamescore = if @me == @they
      3 # draw
    else
      WinLogic[@me] == @they ? 6 : 0
    end

    gamescore + ShapePoints[@me]
  end

  private

  def decode(char)
    DecodeMap.fetch(char)
  end
end

rounds = File.readlines("input").map { Round.new(*_1.split(' ')) }
puts rounds.sum(&:score)
