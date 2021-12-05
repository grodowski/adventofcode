# frozen_string_literal: true

Line = Struct.new(:x0, :y0, :x1, :y1) do
  def self.from_input(line_str)
    x0, y0, x1, y1 = *line_str.scan(/\d+/).map(&:to_i)
    x0 <= x1 ? new(x0, y0, x1, y1) : new(x1, y1, x0, y0)
  end

  def axial?
    x0 == x1 || y0 == y1
  end

  def draw
    # works just for axial
    points = []
    if x0 == x1 && y0 < y1
      y0.upto(y1) { |y| points << [x0, y] }
    elsif x0 == x1 && y0 > y1
      y1.upto(y0) { |y| points << [x0, y] }
    elsif y0 == y1
      x0.upto(x1) { |x| points << [x, y0] }
    end
    points
  end
end

lines = File.read('input').lines.map { Line.from_input(_1) }.keep_if(&:axial?)

size_x = [lines.map(&:x0).max, lines.map(&:x1).max].max + 1
size_y = [lines.map(&:y0).max, lines.map(&:y1).max].max + 1

# find overlapping points on the plane
world_rows = Array.new(size_y) { Array.new(size_x, 0) }
lines.map { _1.draw }.flatten(1).each do |x, y|
  puts "#{x}, #{y}"
  world_rows[y][x] += 1
end

count_gte_two = 0 # select points >= 2
world_rows.each_with_index do |row, _y|
  row.each_with_index { |freq, _x| count_gte_two += 1 if freq >= 2 }
end
puts "Answer: #{count_gte_two}"
