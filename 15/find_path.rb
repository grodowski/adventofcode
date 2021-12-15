# frozen_string_literal: true
require "set"
require "pry"

Point2d = Struct.new(:x, :y, :risk) do
  def ==(other)
    other.x == self.x && other.y == self.y
  end
end

class Dijkstra
  def initialize(points)
    @points = points
    @flat_points = @points.flatten
    @x_max = @flat_points.map(&:x).max
    @y_max = @flat_points.map(&:y).max
    @start = @flat_points.first
    @end = @points[@y_max][@x_max]
  end

  def search
    open_set = Set.new([@start])
    # map from Point2d to Point2d
    # reconstructs the best path
    prev = {}
    # score for each Point2d, given it's located on the best path
    scores = Hash.new { Float::INFINITY }
    scores[@start] = 0

    while open_set.size > 0
      current = open_set.min_by { scores[_1] }
      open_set.delete(current)
      return scores[current] if current == @end

      each_neighbour(current) do |neighbour|
        alt = scores[current] + neighbour.risk
        if alt < scores[neighbour]
          prev[neighbour] = current
          scores[neighbour] = alt
          open_set.add(neighbour)
        end
      end
    end
  end

  def each_neighbour(point)
    yield @points[point.y][point.x - 1] if point.x > 0
    yield @points[point.y][point.x + 1] if point.x < @x_max
    yield @points[point.y - 1][point.x] if point.y > 0
    yield @points[point.y + 1][point.x] if point.y < @y_max
  end
end

cave_map_points = File.read("input").lines.map.with_index do |row, y|
  row.chomp.chars.map.with_index do |risk, x|
    Point2d.new(x, y, risk.to_i)
  end
end

puts "Answer 1: #{Dijkstra.new(cave_map_points).search}"

def map_5x
  original = File.read("input").lines.map do |row|
    row.chomp.chars.map(&:to_i)
  end
  increase = proc { _1 < 9 ? _1 + 1 : 1 }
  copy = proc { _1.map(&increase) }
  # go right
  original = original.map do |row|
    chunks = []
    4.times do |n|
      to_copy = chunks.last || row
      chunks << copy.(to_copy)
    end
    row + chunks.flatten(1)
  end

  # go down
  chunks = []
  4.times do |n|
    to_copy = chunks.last || original
    chunks << to_copy.map(&copy)
  end
  original + chunks.flatten(1)
end

cave_map_points_5x5 = map_5x.map.with_index do |row, y|
  row.map.with_index { |risk, x| Point2d.new(x, y, risk) }
end
puts "Answer 2: #{Dijkstra.new(cave_map_points_5x5).search}"
