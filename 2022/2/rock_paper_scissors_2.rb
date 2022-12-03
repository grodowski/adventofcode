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
    "X" => :lose,
    "Y" => :draw,
    "Z" => :win,
  }

  ShapePoints = {
    rock: 1,
    paper: 2,
    scissors: 3,
  }

  WinLogic = {
    scissors: :rock,
    rock: :paper,
    paper: :scissors,
  }

  LossLogic = WinLogic.invert

  def initialize(them, objective)
    @them = decode(them)
    @objective = decode(objective)
  end

  def score
    case @objective
    when :lose
      @me = LossLogic[@them]
    when :draw
      @me = @them
    when :win
      @me = WinLogic[@them]
    end

    gamescore = case @objective
      when :draw then 3
      when :win then 6
      else 0
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
