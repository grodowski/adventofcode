# frozen_string_literal: true
require 'set'

Board = Struct.new(:rows, :marked) do
  def self.from_s(rows_string)
    new(rows_string.lines.map { _1.split(' ').map(&:to_i) }, [])
  end

  def columns
    @columns ||= rows.transpose
  end

  def won?
    @won ||= rows.any? { all_marked? _1 } || columns.any? { all_marked? _1 }
  end

  def score
    rows.flatten.reject { marked.include?(_1) }.sum * marked.last
  end

  def mark(number)
    marked.append(number) unless won?
  end

  private

  def all_marked?(list)
    list.all? { marked.include?(_1) }
  end
end

numbers, *boards = File.read('input').split("\n\n")
numbers = numbers.split(',').map(&:to_i)
marked = []
boards = boards.map { Board.from_s(_1) }

winner = nil
complete = []
numbers.each do |mark|
  marked << mark
  boards.each { _1.mark(mark) }
  winner = boards.find(&:won?)
  if winner
    complete << winner
    break
  end
end

puts "Winner! #{winner}"
puts "Answer: #{winner.score}"

# Part two - find the board that wins last (let squid win the game)
last_winner = nil
(numbers - marked).each do |mark|
  boards.each { _1.mark(mark) }
  last_winners = (boards - complete).select(&:won?)
  complete += last_winners if last_winners.any?
end

last_winner = complete.last
puts "Last winner! #{last_winner} boards won #{boards.count(&:won?)}"
puts "Answer: #{last_winner.score}"